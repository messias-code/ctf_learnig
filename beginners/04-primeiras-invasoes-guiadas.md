# 4. Primeiras invasões guiadas

[⬅ Ferramentas](03-ferramentas.md) · [Sumário](README.md) · [Próximo: Metodologia e cola ➡](05-metodologia-e-cola.md)

## Por que isso vem agora

Você conhece cada ferramenta separada. Agora vai ver como elas se encaixam numa invasão inteira, do Nmap até a root flag, com o TryHackMe ainda segurando sua mão.

## Como fazer estas salas

O objetivo aqui **não é** terminar rápido. É entender cada passo. Então:

1. Antes de rodar um comando que a sala mandou, diga para você mesmo **por que** ele está ali.
2. Depois de rodar, leia a saída inteira. Não pule para a resposta.
3. Preencha o [modelo de anotações](05-metodologia-e-cola.md#-modelo-de-anotações-por-sala) como se fosse um CTF de verdade.
4. Quando terminar, feche tudo e tente **refazer a sala sem ler as instruções**, só com suas anotações. Se conseguir, você aprendeu.

O passo 4 parece perda de tempo. É o passo mais importante do guia inteiro.

## Salas desta fase (faça na ordem)

- [ ] **Vulnversity** (Walkthrough)
  Linux. Nmap, Gobuster para achar uma página de upload, burlar o filtro de extensão com o Burp, shell reverso em PHP e root por um binário SUID. É **a receita completa** de CTF iniciante numa sala só.

- [ ] **Blue** (Walkthrough)
  Windows. Sua primeira invasão de Windows, usando uma falha famosa (EternalBlue, a do ransomware WannaCry) com o Metasploit. Depois, quebrar hashes de senha do Windows com o John.

- [ ] **Kenobi** (Walkthrough)
  Linux. Enumerar compartilhamentos SMB, abusar de um serviço FTP com falha conhecida para roubar uma chave SSH e virar root manipulando o `PATH`. Ensina a juntar pistas de serviços diferentes.

- [ ] **Basic Pentesting** (Challenge, mas com perguntas que guiam)
  Linux. Enumeração de SMB, força bruta no SSH com o Hydra e quebra de chave SSH com o John. É a ponte entre "guiado" e "sozinho".

## ✅ Teste: estou pronto?

- [ ] Refiz a **Vulnversity** do zero usando só minhas anotações.
- [ ] Consigo explicar as 4 etapas (reconhecimento, enumeração, acesso inicial, escalação) usando a Vulnversity como exemplo.
- [ ] Sei montar e receber um shell reverso sem copiar da sala.
- [ ] Tenho um arquivo de anotações para cada uma das 4 salas.

[⬅ Ferramentas](03-ferramentas.md) · [Sumário](README.md) · [Próximo: Metodologia e cola ➡](05-metodologia-e-cola.md)
