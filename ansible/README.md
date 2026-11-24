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
| `inventory.yml` | Diz ao Ansible para rodar na própria máquina |
| `ansible.cfg` | Aponta o inventário e pede a senha do sudo |

Para instalar mais ferramentas, acrescente o nome na lista `pacotes` do `site.yml`.

## Depois de rodar

Abra um terminal novo para os grupos valerem. O Win-KeX fica instalado e pronto. Para abrir a interface gráfica quando quiser, use `kex --win -s`. Na primeira vez ele pede para criar uma senha do VNC.
