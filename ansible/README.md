# 🐉🤖 Kali CTF Workstation on WSL2

> Automação com Ansible para configurar o **Kali Linux no WSL2** como ambiente de CTF: ferramentas de pentest (`kali-linux-headless`), wordlists (`seclists`, `rockyou`) e interface gráfica (**Win-KeX**) — **sem nenhuma tela azul** no meio da instalação.
> "Automatize tudo o que puder, documente o resto."

_É a versão automatizada do guia [wsl2_kali.md](../wsl2_kali.md), no mesmo padrão do [orion-workstation](https://github.com/messias-code/orion-workstation)._

---

## 📑 Sumário
- [Sobre o Projeto](#-sobre-o-projeto)
- [Estrutura do Projeto](#-estrutura-do-projeto)
- [Funcionalidades](#-funcionalidades)
- [Como as telas azuis são respondidas](#-como-as-telas-azuis-são-respondidas)
- [Pré-requisitos](#-pré-requisitos)
- [Instalação](#-instalação)
- [Uso](#-uso)
- [Personalização de Instalação](#️-personalização-de-instalação)
- [Verificação](#-verificação)
- [Variáveis do Sistema](#-variáveis-do-sistema)
- [O que continua manual](#️-o-que-continua-manual)

## 🚀 Sobre o Projeto

Instalar o Kali no WSL2 na mão envolve um `apt install` demorado que para **7 vezes** pedindo respostas em telas de configuração (libc6, teclado, kismet, macchanger, wireshark, sslh). Se você não estiver olhando, a instalação fica parada; se responder errado, precisa reconfigurar depois.

Este playbook pré-responde essas perguntas e executa todas as etapas do guia de uma vez. Cada etapa pode ser ligada ou desligada, e rodar de novo é seguro (o Ansible só altera o que ainda não está configurado).

## 📁 Estrutura do Projeto

```
ansible/
├── README.md                        # Este arquivo
├── ansible.cfg                      # Configuração do Ansible (inventário, roles, senha do sudo)
├── inventory                        # Inventário do Ansible
│   ├── group_vars
│   │   └── all.yml                  # Liga/desliga cada etapa (true/false)
│   └── wsl.yml                      # Host: localhost (o próprio Kali)
├── playbooks
│   └── site.yml                     # Playbook principal
└── roles
    ├── update_system                # apt update + dist-upgrade
    │   └── tasks/main.yml
    ├── kali_tools                   # Telas pré-respondidas + kali-linux-headless, seclists, wordlists
    │   ├── defaults/main.yml        # Lista de pacotes e respostas das 7 telas
    │   └── tasks/main.yml
    ├── wordlists                    # Descompacta a rockyou.txt
    │   └── tasks/main.yml
    └── win_kex                      # Instala o Win-KeX
        └── tasks/main.yml
```

## 💡 Funcionalidades

| Role | O que faz | Etapa do guia |
|------|-----------|---------------|
| `update_system` | `apt update` + `dist-upgrade` | 2 |
| `kali_tools` | Pré-responde as 7 telas, instala `kali-linux-headless`, `seclists` e `wordlists`, e adiciona seu usuário aos grupos `kismet` e `wireshark` | 2 e 3 |
| `wordlists` | Descompacta `/usr/share/wordlists/rockyou.txt.gz` (só se a `.txt` ainda não existir) | 4 |
| `win_kex` | Instala o `kali-win-kex` | 5 |

> 💡 Os grupos `kismet` e `wireshark` permitem capturar pacotes **sem sudo**. Lembre-se de abrir um novo terminal (ou `wsl --shutdown` no Windows) para o grupo novo valer.

## 🎯 Como as telas azuis são respondidas

As telas são perguntas do **debconf**, o sistema de configuração de pacotes do Debian/Kali. O módulo `ansible.builtin.debconf` grava as respostas **antes** do `apt install`, e a instalação roda com `DEBIAN_FRONTEND=noninteractive`, então nenhuma tela é exibida.

As respostas ficam em `roles/kali_tools/defaults/main.yml`:

| # | Tela | Chave do debconf | Resposta |
|---|------|------------------|----------|
| 1 | libc6 — reiniciar serviços sem perguntar | `libraries/restart-without-asking` | `true` |
| 2 | Layout do teclado | `keyboard-configuration/xkb-keymap` · `layoutcode` · `variant` | `us` · `us` · `English (US)` |
| 3 | kismet — setuid root | `kismet-capture-common/install-setuid` | `true` |
| 4 | kismet — usuários do grupo | `kismet-capture-common/install-users` | seu usuário (automático) |
| 5 | macchanger — trocar MAC automaticamente | `macchanger/automatically_run` | `false` |
| 6 | wireshark — usuários comuns capturam pacotes | `wireshark-common/install-setuid` | `true` |
| 7 | sslh — modo de execução | `sslh/inetd_or_standalone` | `standalone` |

> 🔎 Quer descobrir a chave de outra tela? Depois de responder uma vez na mão, rode:
> ```bash
> sudo apt install -y debconf-utils
> sudo debconf-get-selections | grep <nome-do-pacote>
> ```

## 📋 Pré-requisitos

- Windows 10/11 com WSL2
- Kali instalado no WSL (`wsl --install -d kali-linux` no PowerShell — [etapa 1 do guia](../wsl2_kali.md#1️⃣-instalar-o-kali-no-wsl))
- Acesso à internet
- Senha do sudo do seu usuário do Kali

## 🔧 Instalação

### 1. Instalar o Ansible

No Kali, o Ansible já está no repositório oficial (não precisa de PPA como no Ubuntu):

```bash
sudo apt update
sudo apt install -y ansible git
```

### 2. Entrar na pasta do projeto

```bash
cd ctf_learnig/ansible
```

> ⚠️ Rode sempre **de dentro da pasta `ansible/`** — é dela que o `ansible.cfg` é lido. Evite deixar o projeto em `/mnt/c/...`: o Ansible ignora o `ansible.cfg` em pastas com permissão de escrita para todos (caso das pastas do Windows montadas no WSL).

Este projeto só usa módulos do `ansible.builtin`, então **não precisa** instalar collections.

## 📦 Uso

```bash
ansible-playbook playbooks/site.yml
```

> **OBS:** o `ansible.cfg` já tem `become_ask_pass = true`, então ele pede a **senha do sudo** logo no início (`BECOME password:`) — não precisa passar `--ask-become-pass`.

⏳ A instalação do `kali-linux-headless` demora bastante e o Ansible fica parado nessa task sem mostrar progresso. É normal — não interrompa.

Para ver antes o que seria feito, sem alterar nada:

```bash
ansible-playbook playbooks/site.yml --check
```

Após a execução:
1. Abra um novo terminal (para os grupos `kismet`/`wireshark` valerem)
2. Inicie a interface gráfica com `kex --win -s` e crie a senha do VNC na primeira vez

## 🎛️ Personalização de Instalação

Edite `inventory/group_vars/all.yml` e defina `true` ou `false` para cada etapa:

```YAML
setup:
  update_system: true
  kali_tools: true
  wordlists: true
  win_kex: true
```

Outras personalizações, em `roles/kali_tools/defaults/main.yml`:

- **`kali_packages`** — adicione pacotes à lista (ex.: `kali-linux-large`, `gobuster`, `feroxbuster`)
- **`kali_user`** — usuário dos grupos kismet/wireshark (padrão: quem rodou o playbook)
- **`kali_debconf`** — altere qualquer resposta das telas

Também dá para sobrescrever na linha de comando:

```bash
ansible-playbook playbooks/site.yml -e kali_user=outro_usuario
```

## 🧪 Verificação

Confira se tudo ficou como esperado:

```bash
# Respostas gravadas no debconf
sudo debconf-show kismet-capture-common wireshark-common macchanger sslh

# Wordlists
ls -lh /usr/share/wordlists/rockyou.txt
ls /usr/share/seclists

# Grupos do seu usuário (precisa ter kismet e wireshark)
groups

# Win-KeX
kex --help
```

## 🔍 Variáveis do Sistema

O Ansible usa "facts" para coletar informações do sistema. As variáveis usadas neste playbook são:

| Variável | Comando para Verificar | Descrição |
|----------|------------------------|-----------|
| `ansible_user_id` | `whoami` | Nome do usuário que rodou o playbook — usado como padrão do `kali_user` |
| `setup.*` | `cat inventory/group_vars/all.yml` | Liga/desliga cada role |

## ✋ O que continua manual

| Etapa | Por quê |
|-------|---------|
| `wsl --install -d kali-linux` | Roda no PowerShell do Windows, antes do Kali existir |
| Senha do VNC do Win-KeX | É criada interativamente no primeiro `kex --win -s` |
