# 🐉 Kali CTF no WSL2 com Ansible

Deixa o Kali no WSL2 pronto para CTF com um comando. As telas azuis de configuração já vêm respondidas, então você não precisa ficar olhando a instalação.

## O que ele faz

- Atualiza o sistema
- Instala `kali-linux-headless`, `seclists`, `wordlists` e `kali-win-kex`
- Deixa seu usuário capturar pacotes sem sudo (grupos `kismet` e `wireshark`)
- Descompacta a `rockyou.txt` em `/usr/share/wordlists/`

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

Ele pede a senha do sudo no início. A instalação das ferramentas demora e não mostra progresso, então é só esperar.

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

3. Conecte:

```bash
sudo openvpn ~/ctf_learnig/start_ctf.ovpn
```

> O `.gitignore` ignora `*.ovpn`, então o arquivo nunca vai para o GitHub.

## Desfazer

```bash
ansible-playbook rollback.yml
```

Remove as ferramentas, as wordlists e o Win-KeX, junto com o que veio com eles (kismet, wireshark etc.). Também apaga a `rockyou.txt`, tira você dos grupos `kismet` e `wireshark` e desfaz as respostas das telas. A atualização do sistema (`apt upgrade`) não tem como desfazer. Se você tiver adicionado pacotes na lista `pacotes` do `site.yml`, coloque os mesmos na lista do `rollback.yml`.

## Depois de rodar

Abra um terminal novo para os grupos valerem. O Win-KeX fica instalado e pronto. Para abrir a interface gráfica quando quiser, use `kex --win -s`. Na primeira vez ele pede para criar uma senha do VNC.
