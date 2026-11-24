#!/usr/bin/env bash
# Liga, testa e desliga a VPN do TryHackMe em segundo plano.
#
#   ./vpn.sh start   conecta
#   ./vpn.sh test    confere se a VPN está ligada e alcança a rede do TryHackMe
#   ./vpn.sh test IP confere a VPN e também se a máquina do laboratório responde
#   ./vpn.sh stop    desconecta
set -euo pipefail

PASTA="$(cd "$(dirname "$0")" && pwd)"
OVPN="$PASTA/start_ctf.ovpn"
LOG=/run/thm-vpn.log
PID=/run/thm-vpn.pid
ESPERA=30

if [[ -t 1 ]]; then
  VERDE=$'\e[32m' VERMELHO=$'\e[31m' AMARELO=$'\e[33m' CINZA=$'\e[90m' FIM=$'\e[0m'
else
  VERDE='' VERMELHO='' AMARELO='' CINZA='' FIM=''
fi

ok()    { echo "${VERDE}[+]${FIM} $*"; }
erro()  { echo "${VERMELHO}[-]${FIM} $*"; }
aviso() { echo "${AMARELO}[!]${FIM} $*"; }
dica()  { echo "    ${CINZA}$*${FIM}"; }

meu_ip()  { ip -4 -o addr show tun0 2>/dev/null | awk '{print $4}' | cut -d/ -f1; }
gateway() { ip route show dev tun0 2>/dev/null | awk '/via/ {print $3; exit}'; }
ligada()  { [[ -r "$PID" ]] && ps -p "$(cat "$PID")" >/dev/null 2>&1; }

# Faz ping e devolve a média em ms (sem saída se não responder)
latencia() {
  local resposta
  resposta=$(ping -c 3 -W 2 "$1" 2>/dev/null) || return 1
  awk -F/ '/^rtt/ {printf "%d", $5}' <<<"$resposta"
}

start() {
  if ligada; then
    ok "A VPN já está ligada  ·  seu IP: $(meu_ip)"
    return
  fi
  if [[ ! -f "$OVPN" ]]; then
    erro "Não achei o $OVPN"
    dica "Baixe em https://tryhackme.com/access (veja ansible/README.md)"
    exit 1
  fi
  if pgrep -x openvpn >/dev/null; then
    erro "Já tem um openvpn aberto fora deste script"
    dica "Feche com: sudo pkill -x openvpn"
    exit 1
  fi

  echo "Conectando..."
  sudo rm -f "$LOG"
  # Os avisos do openvpn só aparecem se ele não conseguir iniciar
  local saida
  if ! saida=$(sudo openvpn --config "$OVPN" --daemon thm-vpn --log "$LOG" --writepid "$PID" 2>&1); then
    erro "O openvpn não iniciou:"
    echo "$saida"
    exit 1
  fi

  for ((i = 0; i < ESPERA; i++)); do
    if sudo grep -q "Initialization Sequence Completed" "$LOG" 2>/dev/null; then
      ok "VPN conectada  ·  seu IP: $(meu_ip)"
      return
    fi
    ligada || break
    sleep 1
  done

  erro "A VPN não conectou. Final do log:"
  sudo tail -n 10 "$LOG" 2>/dev/null | sed 's/^/    /' || true
  dica "Baixe o .ovpn de novo em https://tryhackme.com/access"
  stop >/dev/null
  exit 1
}

test_vpn() {
  if ! ligada; then
    erro "VPN desligada"
    dica "Ligue com: $0 start"
    exit 1
  fi
  local alvo="${1:-}" gw ms
  gw=$(gateway)
  if [[ -n "$gw" ]] && ms=$(latencia "$gw"); then
    ok "VPN funcionando  ·  seu IP: $(meu_ip)  ·  ${ms} ms"
  else
    aviso "VPN ligada, mas a rede do TryHackMe não respondeu"
    dica "Reconecte com: $0 stop && $0 start"
    exit 1
  fi

  [[ -z "$alvo" ]] && return
  if ms=$(latencia "$alvo"); then
    ok "Máquina ligada  ·  $alvo respondeu  ·  ${ms} ms"
  else
    erro "Máquina desligada  ·  sem resposta de $alvo  ·  0 ms"
    exit 1
  fi
}

stop() {
  if ! ligada; then
    [[ -e "$PID" ]] && sudo rm -f "$PID"
    ok "A VPN já estava desligada"
    return
  fi
  sudo kill "$(cat "$PID")"
  for ((i = 0; i < 10; i++)); do
    ligada || break
    sleep 1
  done
  sudo rm -f "$PID"
  ok "VPN desligada"
}

case "${1:-}" in
  start) start ;;
  test)  test_vpn "${2:-}" ;;
  stop)  stop ;;
  *)
    echo "Uso: $0 start | test [IP-da-máquina] | stop"
    exit 1
    ;;
esac
