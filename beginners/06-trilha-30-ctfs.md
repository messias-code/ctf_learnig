# 6. Trilha dos 30 CTFs

[⬅ Metodologia e cola](05-metodologia-e-cola.md) · [Sumário](README.md)

Chegou a hora de fazer sozinho. Estes são 30 desafios **fáceis** do TryHackMe, escolhidos por serem bons para aprender e divertidos (temas criativos, pistas engraçadas, caminhos inesperados). Eles estão em **ordem de dificuldade**: cada um usa o que os anteriores ensinaram e acrescenta algo novo.

## Como fazer cada CTF

1. Siga a [receita](05-metodologia-e-cola.md#-a-receita-de-quase-todo-ctf-iniciante): reconhecimento, enumeração, acesso inicial, escalação.
2. Travou 30 minutos? Leia **só a dica** do ponto onde parou num writeup.
3. Terminou? Leia um writeup inteiro e anote o que você fez diferente.

O campo **Pratica** diz a área de cada sala sem entregar a solução. Não pesquise a resolução antes de tentar.

---

## Bloco 1: Primeiros passos sozinho

Salas muito amigáveis, com pistas generosas. Aqui você confirma que a receita funciona.

- [ ] **1. OhSINT**
  Uma única foto, e a partir dela você descobre onde a pessoa mora, onde trabalha e até a senha do Wi-Fi. Trabalho de detetive, sem invadir nada.
  *Pratica:* metadados de imagem, pesquisa na internet (OSINT).

- [ ] **2. c4ptur3-th3-fl4g**
  Uma sequência de textos codificados, um áudio com mensagem escondida e imagens com segredos. Ótima para ficar amigo do CyberChef.
  *Pratica:* codificações (binário, base64, hex, ROT13, morse), esteganografia.

- [ ] **3. Pickle Rick**
  Tema de Rick and Morty: ajude o Rick a voltar a ser humano achando 3 ingredientes. O primeiro CTF clássico de quase todo mundo.
  *Pratica:* código-fonte, páginas escondidas, execução de comandos pelo site.

- [ ] **4. RootMe**
  O CTF mais "receita de bolo" que existe: portas, pastas, upload, shell, root. Se der certo, você entendeu tudo até aqui.
  *Pratica:* Gobuster, burlar filtro de upload, shell reverso, SUID.

- [ ] **5. Simple CTF**
  Seu primeiro exploit público: achar a versão de um sistema e usar uma falha conhecida contra ele.
  *Pratica:* FTP anônimo, `searchsploit`, rodar exploit pronto, `sudo -l`.

- [ ] **6. Bounty Hacker**
  Tema de Cowboy Bebop. A tripulação deixou arquivos jogados por aí, e um deles é exatamente o que você precisa.
  *Pratica:* FTP anônimo, Hydra no SSH, GTFOBins.

- [ ] **7. Brooklyn Nine Nine**
  Tema da série. Tem **dois caminhos** diferentes para entrar. Faça um, termine, e depois volte e faça o outro.
  *Pratica:* FTP, esteganografia ou força bruta, `sudo -l`.

- [ ] **8. Agent Sudo**
  Você é um agente secreto investigando um servidor no fundo do mar. O site só fala com você se souber "quem" você é.
  *Pratica:* alterar cabeçalhos HTTP (Burp/curl), força bruta, arquivos escondidos em imagens, uma falha famosa do `sudo`.

## Bloco 2: Pegando o jeito

As pistas ficam menos óbvias. Você vai precisar enumerar com mais calma e juntar informação de lugares diferentes.

- [ ] **9. LazyAdmin**
  O administrador foi preguiçoso e deixou coisas que não devia em lugares públicos.
  *Pratica:* Gobuster em camadas, backup exposto, quebrar hash, upload de shell num painel admin.

- [ ] **10. Fowsniff CTF**
  Uma empresa fictícia foi invadida e as senhas dos funcionários vazaram. Você usa o vazamento para entrar. Tem dicas embutidas na sala.
  *Pratica:* OSINT, quebrar hashes, ler e-mail por POP3, scripts que rodam no login.

- [ ] **11. Easy Peasy**
  "Fácil" só no nome: pistas codificadas de vários jeitos e serviços em portas fora do padrão.
  *Pratica:* `nmap -p-`, Gobuster, decodificação, esteganografia, cron.

- [ ] **12. Wgel CTF**
  Curta e elegante. Ensina que um único arquivo esquecido pode valer a máquina inteira.
  *Pratica:* código-fonte, Gobuster recursivo, chave SSH, GTFOBins.

- [ ] **13. Lian_Yu**
  Tema da série Arrow. Pastas com nomes estranhos e arquivos que fingem ser o que não são.
  *Pratica:* Gobuster com wordlist grande, codificações, consertar arquivo corrompido, `sudo -l`.

- [ ] **14. Ignite**
  Uma startup subiu o site sem terminar a instalação do sistema dele. A própria página inicial dá a pista de por onde começar.
  *Pratica:* identificar o sistema e a versão do site, `searchsploit`, exploit público, procurar senhas em arquivos de configuração.

- [ ] **15. Overpass**
  Estudantes de computação sem dinheiro criaram um gerenciador de senhas. O que poderia dar errado?
  *Pratica:* ler JavaScript do site, autenticação quebrada (cookies), quebrar chave SSH, cron.

- [ ] **16. Startup**
  Uma startup com uma configuração "criativa" de FTP e site. No meio do caminho, um arquivo de tráfego de rede para analisar.
  *Pratica:* FTP com escrita, shell reverso, análise de `.pcap` no Wireshark, cron.

## Bloco 3: Pensando fora da caixa

Aqui o tema da sala começa a esconder a resposta. Leia tudo, desconfie de tudo.

- [ ] **17. Chill Hack**
  Um site que roda comandos, mas bloqueia vários. Seu trabalho é dar a volta no bloqueio.
  *Pratica:* injeção de comando com filtro, esteganografia, escalação por grupo do sistema.

- [ ] **18. Cyborg**
  Você acha um backup criptografado e precisa descobrir como abrir.
  *Pratica:* ler arquivos de configuração, quebrar hash, ferramenta de backup desconhecida (leia a documentação!), `sudo -l`.

- [ ] **19. Brute It**
  O nome já diz: tem força bruta, mas no lugar certo e do jeito certo.
  *Pratica:* Hydra em formulário de login web, quebrar chave SSH e hashes do `/etc/shadow`.

- [ ] **20. Anthem**
  **Windows.** Um blog esconde o nome do administrador num poema. Quase nada de ferramenta, muita observação.
  *Pratica:* OSINT dentro do site, `robots.txt`, login por RDP, arquivos ocultos e permissões no Windows.

- [ ] **21. Chocolate Factory**
  Tema da Fantástica Fábrica de Chocolate. Muitas portas abertas, a maioria só para te distrair.
  *Pratica:* enumeração de muitos serviços, esteganografia, execução de comandos, GTFOBins.

- [ ] **22. Year of the Rabbit**
  Cheia de pegadinhas e pistas falsas. Ensina a usar o Burp para ver o que o navegador esconde de você.
  *Pratica:* interceptar redirecionamentos no Burp, arquivos escondidos, linguagem esotérica, falha do `sudo`.

- [ ] **23. GamingServer**
  Um servidor de jogos com uma chave esquecida e uma forma diferente de virar root.
  *Pratica:* código-fonte, Gobuster, quebrar chave SSH, escalação por grupo do sistema (`lxd`).

## Bloco 4: Fechando com estilo

As mais criativas da lista. Se você chegou aqui, já não é mais iniciante.

- [ ] **24. Break Out The Cage**
  Ajude o Nicolas Cage a salvar a carreira e investigue o agente dele. Tem áudio com segredo e mensagens cifradas.
  *Pratica:* espectrograma de áudio, cifra de Vigenère, cron, ler e-mails do sistema.

- [ ] **25. Madness**
  Uma imagem que não abre, um parâmetro secreto e um caminho bem maluco até o root.
  *Pratica:* consertar arquivo no editor hexadecimal, força bruta em parâmetro, ROT, SUID com falha conhecida.

- [ ] **26. Cat Pictures**
  Um fórum de fotos de gatos com uma "batida secreta" para abrir uma porta.
  *Pratica:* *port knocking*, FTP, shell limitado, sair de um container Docker.

- [ ] **27. Jack-of-All-Trades**
  Os serviços estão em portas trocadas de propósito, e até o navegador vai reclamar. Resolva isso e o resto é uma caça ao tesouro.
  *Pratica:* serviços em portas incomuns, configuração do Firefox, codificações, esteganografia, SUID.

- [ ] **28. Team**
  Um site que só aparece se você souber o nome certo, e uma página que lê arquivos que não deveria.
  *Pratica:* virtual hosts (`/etc/hosts`), LFI (ler arquivos do servidor pelo site), injeção em script, cron.

- [ ] **29. Mustacchio**
  Um backup esquecido leva a um painel admin que interpreta XML do jeito errado.
  *Pratica:* backup exposto, quebrar hash, XXE, sequestro de `PATH` num binário SUID.

- [ ] **30. Archangel**
  O "chefão final" da trilha: tudo que você aprendeu, encadeado.
  *Pratica:* virtual hosts, LFI com filtro, envenenamento de log para executar comando, cron, sequestro de `PATH`.

---

## 🏁 Terminou os 30?

Você já sabe invadir máquinas Linux sozinho. Os próximos passos naturais:

### Mais CTFs fáceis para continuar o treino

Na mesma pegada, mais recentes: **Smag Grotto**, **tomghost**, **Lo-Fi**, **Silver Platter**, **The Sticker Shop**, **U.A. High School**, **Cheese CTF**, **Lookup**, **Pyrat**, **Valley**, **Whiterose**, **Blueprint** (Windows).

### Redes Windows e Active Directory

Empresas usam Windows com Active Directory, e é aí que os testes de invasão de verdade acontecem. Faça na ordem:

- [ ] **Active Directory Basics** (Walkthrough): o que é um domínio, usuários, grupos e políticas.
- [ ] **Wreath** (Walkthrough): uma rede inteira com várias máquinas. Você invade a máquina exposta e usa ela como ponte para chegar nas internas. É longa e é o melhor projeto de encerramento possível.

[⬅ Metodologia e cola](05-metodologia-e-cola.md) · [Sumário](README.md)
