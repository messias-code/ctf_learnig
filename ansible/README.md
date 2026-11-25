# 🐉 Kali CTF no WSL2 com Ansible

Deixa o Kali no WSL2 pronto para CTF com um comando. As telas azuis de configuração já vêm respondidas, então você não precisa ficar olhando a instalação.

## O que ele faz

- Atualiza o sistema
- Instala `kali-linux-headless`, `seclists`, `wordlists` e `kali-win-kex`
- Instala as ferramentas que o [guia para iniciantes](../beginners/README.md) usa e que não vêm no headless: `burpsuite`, `wireshark`, `steghide`, `stegseek`, `sonic-visualiser`, `hexedit` e `rlwrap`
- Deixa seu usuário capturar pacotes sem sudo (grupos `kismet` e `wireshark`)
- Descompacta a `rockyou.txt` em `/usr/share/wordlists/`
- Baixa e descompacta a wordlist completa da [CrackStation](https://crackstation.net/crackstation-wordlist-password-cracking-dictionary.htm) em `/usr/share/wordlists/crackstation.txt` (4,5 GB de download, ~15 GB no disco; demora)
- Instala o Claude Code (`claude`) e o Antigravity CLI (`agy`) no seu usuário
- Troca o hostname para `labs` (vale depois de `wsl --shutdown`)
- Gera a chave SSH `~/.ssh/id_ed25519` com o comentário `usuario@labs`, protegida por uma senha que você digita na hora (se a chave já existir, ela não é tocada)

## Como usar

**1. Instale o Kali** (PowerShell no Windows):

```powershell
wsl --install -d kali-linux
```

**2. Instale o Ansible e rode o playbook** (no Kali, dentro desta pasta):

```bash
sudo apt update && sudo apt install -y ansible
ansible-playbook site.yml
```

Rode **sem `sudo`**: o playbook usa o seu usuário e para com erro se for o root. Ele pede a senha do sudo no início e, em seguida, a senha da chave SSH (duas vezes, para confirmar). A instalação das ferramentas demora e não mostra progresso, então é só esperar.

## Arquivos

| Arquivo | Para quê |
|---------|----------|
| `site.yml` | O playbook: pacotes, respostas das telas e tarefas |
| `rollback.yml` | Desfaz o que o `site.yml` fez |
| `inventory.yml` | Diz ao Ansible para rodar na própria máquina |
| `ansible.cfg` | Aponta o inventário e pede a senha do sudo |

Para instalar mais ferramentas, acrescente o nome na lista `pacotes` do `site.yml`.

## VPN do TryHackMe (manual)

1. No Windows, baixe o `.ovpn` em [tryhackme.com/access](https://tryhackme.com/access).
2. No Kali, mova para o repositório já com o nome `start_ctf.ovpn` e deixe só você com acesso (o arquivo tem a chave da sua VPN):

```bash
mv /mnt/c/Users/<seu-usuario-do-windows>/Downloads/<arquivo-baixado>.ovpn ~/ctf_learnig/start_ctf.ovpn
chmod 600 ~/ctf_learnig/start_ctf.ovpn
```

3. Conecte com o script `vpn.sh` (fica na raiz do repositório). Ele roda a VPN em segundo plano, espera conectar e mostra seu IP na VPN:

```bash
~/ctf_learnig/vpn.sh start   # conecta
~/ctf_learnig/vpn.sh test    # está funcionando? qual meu IP?
~/ctf_learnig/vpn.sh test 10.64.12.34   # também confere se a máquina do laboratório responde
~/ctf_learnig/vpn.sh stop    # desconecta
```

O log da conexão fica em `/run/thm-vpn.log` (leia com `sudo cat`).

> O `.gitignore` ignora `*.ovpn`, então o arquivo nunca vai para o GitHub.

## Desfazer

```bash
ansible-playbook rollback.yml
```

Remove as ferramentas, as wordlists e o Win-KeX, junto com o que veio com eles (kismet, wireshark etc.). Também apaga a `rockyou.txt` e a `crackstation.txt`, tira você dos grupos `kismet` e `wireshark`, desfaz as respostas das telas, remove o Claude Code e o Antigravity CLI e volta o hostname ao padrão do WSL (nome do Windows, depois de `wsl --shutdown`). Os dados de sessão deles (`~/.claude`, `~/.claude.json`, `~/.gemini`, `~/.config/antigravity`) também são apagados: login, conversas e configurações. Para usar de novo, é preciso logar outra vez.

> ⚠️ O rollback **apaga tudo dentro de `~/.ssh`**: chaves, `known_hosts`, `authorized_keys`, tudo. Faça backup antes se precisar de alguma chave. A atualização do sistema (`apt upgrade`) não tem como desfazer. Se você tiver adicionado pacotes na lista `pacotes` do `site.yml`, coloque os mesmos na lista do `rollback.yml`.

## Depois de rodar

Rode `wsl --shutdown` no PowerShell e abra o Kali de novo para o hostname `labs` e os grupos valerem. O Win-KeX fica instalado e pronto. Para abrir a interface gráfica quando quiser, use `kex --win -s`. Na primeira vez ele pede para criar uma senha do VNC.
