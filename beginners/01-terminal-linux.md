# 1. Terminal e Linux

[⬅ Antes de começar](00-antes-de-comecar.md) · [Sumário](README.md) · [Próximo: Redes e Web ➡](02-redes-e-web.md)

## Por que isso vem primeiro

Quase todas as máquinas que você vai invadir rodam Linux. E quando você entrar nelas, **não vai ter mouse nem janela**: só um terminal. Se você não souber andar pelas pastas e ler arquivos, vai invadir a máquina e não saber achar a flag que está do seu lado.

## O básico em 5 minutos

### Pastas e caminhos

No Linux tudo começa na pasta `/` (chamada de **raiz**). Dentro dela existem outras:

```
/
├── home/          ← pastas dos usuários (a sua é /home/seu-usuario, ou ~)
├── root/          ← pasta do administrador (root). A root flag costuma estar aqui
├── etc/           ← arquivos de configuração do sistema
├── var/www/html/  ← onde costumam ficar os arquivos dos sites
├── tmp/           ← pasta temporária que qualquer um pode escrever
└── usr/share/wordlists/  ← suas wordlists no Kali
```

- **Caminho absoluto**: começa com `/`. Ex.: `/etc/passwd`. Funciona de qualquer lugar.
- **Caminho relativo**: não começa com `/`. Ex.: `notas/sala1.md`. É relativo à pasta onde você está.
- `~` é atalho para a sua pasta pessoal. `.` é "a pasta atual". `..` é "a pasta de cima".

### Os comandos que você vai usar todo dia

| Comando | Para que serve | Exemplo |
|---------|---------------|---------|
| `pwd` | Mostra em que pasta você está | `pwd` |
| `ls` | Lista o que tem na pasta | `ls -la` (mostra também os ocultos, que começam com `.`) |
| `cd` | Entra em uma pasta | `cd /var/www/html`, `cd ..`, `cd ~` |
| `cat` | Mostra o conteúdo de um arquivo | `cat user.txt` |
| `less` | Abre arquivo grande com rolagem (`q` para sair) | `less /etc/passwd` |
| `mkdir` | Cria pasta | `mkdir notas` |
| `touch` | Cria arquivo vazio | `touch teste.txt` |
| `cp` / `mv` / `rm` | Copia / move ou renomeia / apaga | `cp a.txt b.txt` |
| `nano` | Editor de texto simples (`Ctrl+O` salva, `Ctrl+X` sai) | `nano notas.md` |
| `find` | Procura arquivos | `find / -name "user.txt" 2>/dev/null` |
| `grep` | Procura um texto dentro de arquivos | `grep -i "senha" config.php` |
| `whoami` | Mostra qual usuário você é | `whoami` |
| `id` | Mostra seu usuário e seus grupos | `id` |
| `sudo -l` | Lista o que você pode rodar como root | `sudo -l` |
| `man` | Manual de qualquer comando (`q` para sair) | `man ls` |

O `2>/dev/null` do `find` joga fora as mensagens de erro ("permissão negada"), para você ver só o que achou.

### Atalhos que salvam sua vida

- **Tab**: completa nomes de arquivo e comando. Digite `cd /va` e aperte Tab.
- **Seta para cima**: repete comandos anteriores.
- **Ctrl+C**: para o comando que está rodando.
- **Ctrl+Shift+C / Ctrl+Shift+V**: copiar e colar no terminal (o `Ctrl+C` sozinho não copia!).
- **Ctrl+L** ou `clear`: limpa a tela.

### Permissões (isso cai em todo CTF)

Rode `ls -l` e você verá algo assim:

```
-rwxr-xr-- 1 joao devs 1234 Jan 1 10:00 script.sh
```

Os 10 primeiros caracteres dizem quem pode fazer o quê:

```
-   rwx   r-x   r--
│    │     │     └── todos os outros: só ler
│    │     └──────── grupo (devs): ler e executar
│    └────────────── dono (joao): ler, escrever e executar
└─────────────────── tipo: - é arquivo, d é pasta
```

- `r` = ler (*read*), `w` = escrever (*write*), `x` = executar.
- `chmod +x script.sh` dá permissão de executar. `chmod 600 arquivo` deixa só o dono ler e escrever.
- Se aparecer um `s` no lugar do `x` (ex.: `-rwsr-xr-x`), é um arquivo **SUID**: ele roda com o poder do **dono** do arquivo, não de quem rodou. Se o dono for root... você entendeu. Isso vai aparecer muito na escalação de privilégio.

### Usuários

- `/etc/passwd` lista os usuários da máquina. Todo mundo pode ler.
- `/etc/shadow` guarda os hashes das senhas. Só o root pode ler.
- `su nome` troca para outro usuário (pede a senha dele).

## Salas desta fase (faça na ordem)

- [ ] **Linux Fundamentals (Pt1)** (Walkthrough): primeiros comandos, `ls`, `cd`, `cat`, `find`, `grep`.
- [ ] **Linux Strength Training** (Walkthrough): treino de procurar arquivos e mexer em pastas. Vai parecer repetitivo, e é essa a ideia.
- [ ] **Advent of Cyber Prep Track** (Walkthrough): tarefas curtas para pegar o ritmo da plataforma sem pressão.
- [ ] **OverTheWire Bandit, níveis 0 ao 15** (fora do TryHackMe: [overthewire.org/wargames/bandit](https://overthewire.org/wargames/bandit/)): cada nível é uma mini flag escondida no Linux. É o melhor treino de terminal que existe, e ensina na prática o que as partes 2 e 3 do Linux Fundamentals (pagas) ensinariam: entrar por SSH, permissões, processos e mais. Anote a senha de cada nível no seu arquivo de notas.
- [ ] **Ninja Skills** (Challenge): seu primeiro "desafio" de verdade, só que de Linux. Use `find` e `grep` para responder.

## ✅ Teste: estou pronto?

Sem olhar o guia, faça no seu Kali:

- [ ] Vá até `/etc`, liste tudo (inclusive ocultos) e volte para sua pasta pessoal.
- [ ] Encontre onde está o arquivo `rockyou.txt` usando `find`.
- [ ] Conte quantas linhas o `rockyou.txt` tem (dica: `wc -l`).
- [ ] Procure a palavra `root` dentro de `/etc/passwd` com `grep`.
- [ ] Explique o que significa `-rwsr-xr-x root root` e por que isso pode ser perigoso.
- [ ] Explique a diferença entre `/home/joao/flag.txt` e `flag.txt`.

[⬅ Antes de começar](00-antes-de-comecar.md) · [Sumário](README.md) · [Próximo: Redes e Web ➡](02-redes-e-web.md)
