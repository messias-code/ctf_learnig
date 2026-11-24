# 2. Redes e Web

[⬅ Terminal e Linux](01-terminal-linux.md) · [Sumário](README.md) · [Próximo: Ferramentas ➡](03-ferramentas.md)

## Por que isso vem agora

Toda invasão começa com uma pergunta: **"por onde dá para entrar?"**. A resposta é sempre uma porta aberta com um serviço rodando. E em quase todo CTF fácil, esse serviço é um **site**. Sem entender rede e web, as ferramentas da próxima fase vão mostrar resultados que você não vai saber ler.

## Redes em 5 minutos

### IP: o endereço

Todo computador numa rede tem um **IP**, como `10.64.12.34`. Pense no IP como o **endereço de um prédio**.

Dois IPs que você vai usar sempre:

- **IP do alvo**: aparece na sala do TryHackMe quando você liga a máquina.
- **Seu IP na VPN**: o endereço do seu Kali dentro da rede do TryHackMe. Veja com:

  ```bash
  ip a show tun0
  ```

  Procure a linha `inet`, algo como `192.168.155.2` (o `~/ctf_learnig/vpn.sh test` também mostra). Você vai precisar dele quando o alvo tiver que se conectar de volta em você (shell reverso).

### Portas e serviços: os apartamentos do prédio

Se o IP é o prédio, as **portas** são os apartamentos. Existem 65.535. Em cada porta aberta mora um **serviço**. As que mais aparecem:

| Porta | Serviço | O que é | O que procurar em CTF |
|-------|---------|---------|-----------------------|
| 21 | FTP | Troca de arquivos | Login `anonymous` sem senha |
| 22 | SSH | Terminal remoto | Entrar quando achar usuário e senha/chave |
| 25 / 110 / 143 | SMTP / POP3 / IMAP | E-mail | Ler e-mails com senhas |
| 53 | DNS | "Lista telefônica" de nomes de site | Subdomínios escondidos |
| 80 / 8080 | HTTP | Site | Quase sempre o ponto de entrada |
| 443 | HTTPS | Site com cadeado | O mesmo que o 80 |
| 139 / 445 | SMB | Pastas compartilhadas (Windows) | Compartilhamentos abertos |
| 3306 | MySQL | Banco de dados | Senhas fracas |
| 3389 | RDP | Área de trabalho remota do Windows | Entrar com credenciais achadas |

### DNS: nomes viram IPs

Você digita `google.com`, e o DNS traduz para um IP. Em CTF, às vezes o site só funciona pelo nome (ex.: `cheese.thm`). Aí você precisa ensinar seu Kali que aquele nome aponta para o IP do alvo, editando o arquivo `/etc/hosts`:

```bash
echo "10.64.12.34 cheese.thm" | sudo tee -a /etc/hosts
```

Troque o IP sempre que reiniciar a máquina da sala (o IP muda!).

## Web em 5 minutos

### O que acontece quando você abre um site

1. Seu navegador manda uma **requisição** (*request*) para o servidor: "me dá a página `/login`".
2. O servidor responde com um **código** e o conteúdo da página.

Códigos que você precisa reconhecer:

| Código | Significado | Em CTF |
|--------|-------------|--------|
| 200 | OK, aqui está | A página existe |
| 301 / 302 | Vá para outro lugar | Redirecionamento, às vezes para o login |
| 403 | Proibido | **A página existe**, só não te deixam ver. Interessante! |
| 404 | Não existe | Nada aqui |
| 500 | Erro no servidor | Você quebrou algo. Às vezes é bom sinal |

### Os dois "métodos" principais

- **GET**: pedir uma página. Os dados vão na URL: `site.thm/busca?q=gato`.
- **POST**: enviar dados, como um formulário de login. Os dados vão escondidos no corpo da requisição.

### O que um site esconde (e você deve sempre olhar)

- **Código-fonte**: `Ctrl+U` no navegador. Programadores esquecem comentários com senhas, nomes de usuário e pastas secretas.
- **`/robots.txt`**: arquivo que diz aos buscadores o que **não** indexar. Ou seja: uma lista do que o dono queria esconder.
- **Ferramentas do desenvolvedor**: `F12` no navegador. Aba **Network** mostra as requisições; aba **Storage/Application** mostra os **cookies** (o "crachá" que diz ao site quem você é).
- **Pastas escondidas**: páginas que existem mas não têm link. Você vai achá-las com o Gobuster na próxima fase.

## Salas desta fase (faça na ordem)

- [ ] **What is Networking?** (Walkthrough): IP, MAC, ping.
- [ ] **Introductory Networking** (Walkthrough): o modelo OSI (as "camadas" de uma rede, que aparecem em toda entrevista), TCP, UDP e as ferramentas `ping`, `traceroute` e `whois`.
- [ ] **DNS in Detail** (Walkthrough): como nomes viram IPs.
- [ ] **HTTP in Detail** (Walkthrough): requisições, respostas, códigos, cookies.
- [ ] **How Websites Work** (Walkthrough): HTML, JavaScript e o que o navegador mostra.
- [ ] **Exercício final (sem sala):** explique em voz alta, ou escreva nas suas notas, o caminho completo de quando você digita um site no navegador até a página aparecer: DNS, IP, porta, requisição HTTP, resposta e código.

## ✅ Teste: estou pronto?

- [ ] Qual a diferença entre IP e porta? Use a analogia do prédio.
- [ ] Em que porta costuma ficar um site? E o SSH? E o FTP?
- [ ] Achei um `403` em `/admin`. Isso é bom ou ruim para mim? Por quê?
- [ ] Onde eu olho para ver se o programador deixou um comentário esquecido?
- [ ] O que é o `/robots.txt` e por que eu sempre abro ele?
- [ ] O site só abre como `exemplo.thm`. O que eu faço?
- [ ] Como descubro meu próprio IP na VPN?

[⬅ Terminal e Linux](01-terminal-linux.md) · [Sumário](README.md) · [Próximo: Ferramentas ➡](03-ferramentas.md)
