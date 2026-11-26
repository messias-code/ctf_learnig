# 0. Antes de começar

[⬅ Sumário](README.md) · [Próximo: Terminal e Linux ➡](01-terminal-linux.md)

## 🎯 O que é um CTF

**CTF** vem de *Capture The Flag* (capture a bandeira). É um jogo de segurança: alguém prepara um computador cheio de falhas de propósito e esconde nele textos secretos chamados **flags**. Uma flag parece com isto:

```
THM{3st4_3_um4_fl4g}
```

Seu trabalho é invadir a máquina, achar a flag e colar no site para ganhar os pontos. Na maioria das máquinas existem duas:

- **User flag** (`user.txt`): você conseguiu entrar na máquina como um usuário comum.
- **Root flag** (`root.txt`): você virou o administrador da máquina (no Linux ele se chama **root**). Essa é a vitória completa.

## 🏫 O que é o TryHackMe

O [TryHackMe](https://tryhackme.com) (THM) é um site de aulas de segurança. Cada aula é uma **sala** (*room*). Existem dois tipos:

| Tipo | Como é | Quando usar |
|------|--------|-------------|
| **Walkthrough** | Aula guiada: texto explicando + perguntas + máquina para praticar | Fases 1 a 4 |
| **Challenge** | Desafio: só uma máquina e as perguntas. Ninguém te explica nada | Fase 6 |

Crie uma conta gratuita. **Este guia usa somente salas gratuitas**: você não precisa pagar nada. Os nomes foram conferidos no TryHackMe em novembro de 2026.

> O TryHackMe às vezes transforma uma sala gratuita em paga (*Premium*, só para assinantes). Se uma sala deste guia pedir assinatura quando você chegar nela, **pule** e siga para a próxima da lista.

## ⚖️ A regra mais importante: ética e lei

Invadir um computador sem autorização é **crime** no Brasil (Lei 12.737/2012, a "Lei Carolina Dieckmann") e em quase todo o mundo. Não importa se foi "só para testar" ou se "não estragou nada".

Por isso:

- ✅ Ataque **somente** o IP da máquina que você ligou dentro da sala do TryHackMe.
- ❌ Nunca use nada deste guia no Wi-Fi da faculdade, no site da empresa, no celular do amigo ou em qualquer coisa que não seja sua ou que você não tenha autorização **por escrito**.
- ❌ Não ataque a infraestrutura do próprio TryHackMe (o site, a VPN). Só a máquina da sala.

Quem trabalha com isso de verdade (o chamado *pentester*) só começa depois de assinar um contrato dizendo exatamente o que pode ser testado.

## 📖 Palavras que você vai ouvir o tempo todo

Não precisa decorar agora. Volte aqui sempre que esquecer uma.

| Palavra | O que significa, em português simples |
|---------|---------------------------------------|
| **Terminal** / **shell** | A tela preta onde você digita comandos em vez de clicar |
| **Comando** | Uma ordem que você digita no terminal, como `ls` ou `cd` |
| **Linux** | Um sistema operacional, como o Windows. Quase todos os servidores usam |
| **Kali Linux** | Um Linux que já vem com as ferramentas de hacking instaladas |
| **root** | O administrador do Linux. Pode tudo |
| **sudo** | Comando que deixa um usuário comum rodar algo como root |
| **IP** | O "endereço" de um computador na rede. Ex.: `10.64.12.34` |
| **Porta** | Uma "porta de entrada" numerada em um computador. Cada serviço fica em uma. Ex.: site na 80, SSH na 22 |
| **Serviço** | Um programa esperando conexões numa porta (site, FTP, SSH...) |
| **Alvo** / **máquina** / **box** | O computador que você vai invadir |
| **VPN** | Um "túnel" que liga seu computador à rede do TryHackMe, onde o alvo está |
| **Enumeração** / **reconhecimento** | Coletar o máximo de informação sobre o alvo antes de atacar |
| **Exploit** | Código ou técnica que aproveita uma falha |
| **Vulnerabilidade** | A falha em si |
| **CVE** | Número oficial de uma falha conhecida. Ex.: `CVE-2019-9053` |
| **Shell reverso** | Fazer o alvo se conectar de volta no seu computador e te dar um terminal nele |
| **Escalação de privilégio** (*privesc*) | Sair de usuário comum e virar root |
| **Hash** | Uma senha "embaralhada" de um jeito que não dá para desfazer, só adivinhar |
| **Wordlist** | Um arquivo de texto com milhares de palavras (senhas, nomes de pasta) para testar |
| **Força bruta** (*brute force*) | Testar muitas senhas/nomes até um funcionar |
| **Writeup** | Resolução de uma sala escrita por alguém que já fez |
| **Flag** | O texto secreto que prova que você chegou lá |

## 🛠️ Prepare o ambiente

Você vai usar o **Kali Linux dentro do Windows** (pelo WSL2). Este repositório já tem uma automação que instala tudo.

1. Siga o [README do Ansible](../ansible/README.md) do começo ao fim, inclusive a parte **"VPN do TryHackMe (manual)"** e **"Depois de rodar"**.
2. Abra o Kali. Você deve ver algo parecido com:

   ```
   ┌──(seu-usuario㉿labs)-[~]
   └─$
   ```

   Esse texto é o **prompt**: o terminal está esperando você digitar.

> Ainda não entende o que é terminal? Normal. Só siga o README do Ansible copiando e colando os comandos. Na Fase 1 você vai entender o que cada coisa faz.

### Como conectar no TryHackMe e testar

A **VPN** liga o seu Kali à rede do TryHackMe, onde as máquinas-alvo estão. Sem ela, você não alcança o alvo. O repositório tem um script, o `vpn.sh`, que liga a VPN em **segundo plano** (sem prender um terminal) e diz se deu certo.

Todo dia que for estudar, faça assim:

1. Conecte a VPN (ele pede a senha do `sudo`):

   ```bash
   ~/ctf_learnig/vpn.sh start
   ```

   Se deu certo, aparece:

   ```
   Conectando...
   [+] VPN conectada  ·  seu IP: 192.168.155.2
   ```

   Anote esse **IP na VPN**. É o endereço do seu Kali para o alvo, e você vai precisar dele para receber shells reversos.

2. Confira se a VPN está funcionando (pode rodar sempre que quiser, por exemplo se esquecer se ligou):

   ```bash
   ~/ctf_learnig/vpn.sh test
   ```

   ```
   [+] VPN funcionando  ·  seu IP: 192.168.155.2  ·  149 ms
   ```

   Se aparecer `[-]` ou `[!]`, a linha de baixo diz o que fazer.

3. Na sala do TryHackMe, clique em **Start Machine** e espere o IP do alvo aparecer (leva de 1 a 5 minutos). Hoje eles costumam começar com `10.6` ou `10.7`, como `10.64.12.34`.
4. Teste se o alvo responde com o `ping` (troque pelo IP que apareceu):

   ```bash
   ping -c 4 10.64.12.34
   ```

   O `ping` manda 4 pacotes (`-c 4`) e espera a resposta. Linhas com `bytes from` significam que o alvo está no ar. `100% packet loss` significa que não respondeu: espere mais um minuto e tente de novo. Máquinas Windows às vezes não respondem ping mesmo estando ligadas; nesse caso siga em frente.

   Atalho: passando o IP para o `test`, ele confere a VPN **e** a máquina de uma vez:

   ```bash
   ~/ctf_learnig/vpn.sh test 10.64.12.34
   ```

   ```
   [+] VPN funcionando  ·  seu IP: 192.168.155.2  ·  149 ms
   [+] Máquina ligada  ·  10.64.12.34 respondeu  ·  150 ms
   ```

   Se a máquina não estiver no ar, a segunda linha vira `[-] Máquina desligada  ·  sem resposta de 10.64.12.34  ·  0 ms`. Você continua na VPN, só o alvo que não respondeu.

5. Terminou de estudar? Desligue:

   ```bash
   ~/ctf_learnig/vpn.sh stop
   ```

### O que o script faz por baixo (e como desligar na mão)

Entender isso ajuda quando algo dá errado, e você vai usar as mesmas ideias (processos, `kill`) dentro das máquinas que invadir.

- Ligar: o script roda `sudo openvpn --config start_ctf.ovpn --daemon ...`. O `--daemon` manda o programa para o **segundo plano**: ele continua rodando sem ocupar o terminal. As mensagens que antes apareciam na tela vão para o arquivo `/run/thm-vpn.log`. Para ler: `sudo cat /run/thm-vpn.log`.
- Testar: o script dá `ping` no **gateway** da VPN, o computador do TryHackMe que fica na outra ponta do túnel. Se ele responde, o túnel está funcionando.
- Todo programa rodando é um **processo**, e cada processo tem um número, o **PID**. Para ver o da VPN:

  ```bash
  pgrep -a openvpn
  ```

  A resposta é algo como `4321 openvpn --config ...`. O `4321` é o PID.

- Desligar na mão é **matar o processo**: mandar um sinal pedindo para ele terminar.

  ```bash
  sudo kill 4321          # pelo número (PID)
  sudo pkill -x openvpn   # pelo nome, sem precisar saber o número
  ```

  Use isso se o script travar ou se você tiver aberto a VPN do jeito antigo (`sudo openvpn start_ctf.ovpn` num terminal). Nesse caso, `Ctrl+C` nesse terminal também desliga.

Avisos como `DEPRECATED OPTION`, `mssfix cannot be used` ou `Kernel support for ovpn interfaces missing` no log são **normais** e não atrapalham. O que importa é a linha `Initialization Sequence Completed`, e o script já procura por ela.

> O TryHackMe também oferece a **AttackBox**, um Kali que abre no navegador. Ela funciona, mas a conta gratuita tem tempo limitado por dia. Use o seu Kali como padrão e a AttackBox só se a VPN der problema.

## 📝 Anotações

Anote o que encontrar em cada sala: IPs, portas, senhas, comandos que funcionaram e ideias que não deram certo. O formato é com você. Pode ser um `.md` por sala, um caderno, o que funcionar melhor para você. O importante é conseguir reler depois.

## Salas desta fase

- [ ] **Tutorial** (Walkthrough): aprende a ligar uma máquina e responder perguntas no site.
- [ ] **OpenVPN** (Walkthrough): confirma que sua VPN está funcionando.
- [ ] **Starting Out In Cyber Sec** (Walkthrough): visão geral das carreiras. Ajuda a entender para onde isso tudo leva.

## ✅ Teste: estou pronto?

Responda sem olhar:

- [ ] O que é uma flag e qual a diferença entre a user e a root?
- [ ] Posso testar essas técnicas no site da minha empresa se eu não estragar nada? (Resposta: **não**.)
- [ ] Consigo conectar a VPN, ligar uma máquina na sala e dar `ping` nela?
- [ ] Sei onde está a tabela de palavras para consultar quando esquecer algo?

[⬅ Sumário](README.md) · [Próximo: Terminal e Linux ➡](01-terminal-linux.md)
