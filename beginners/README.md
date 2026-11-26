# 🧭 CTF do zero: guia para quem nunca hackeou nada

Este guia é para quem **não sabe nada**: nunca abriu um terminal, não sabe o que é um IP e acha que "porta" é coisa de casa. Tudo bem. A ideia é sair desse ponto e chegar até invadir máquinas sozinho no TryHackMe.

> **Nenhuma etapa é opcional.** Cada fase usa o que a anterior ensinou. Pular uma fase é o jeito mais rápido de travar lá na frente e achar que "não leva jeito". Não é falta de jeito, é falta de base.

## Sumário

| # | Arquivo | O que você aprende | Tempo médio |
|---|---------|--------------------|-------------|
| 0 | [Antes de começar](00-antes-de-comecar.md) | O que é CTF, regras, palavras que você vai ouvir, preparar o ambiente | 1 dia |
| 1 | [Terminal e Linux](01-terminal-linux.md) | Andar pelas pastas, ler arquivos, permissões, usuários | 1 a 2 semanas |
| 2 | [Redes e Web](02-redes-e-web.md) | IP, portas, serviços, como um site funciona por dentro | 1 a 2 semanas |
| 3 | [Ferramentas](03-ferramentas.md) | Nmap, Gobuster, Burp, Hydra, John, shells e escalação de privilégio | 2 a 3 semanas |
| 4 | [Primeiras invasões guiadas](04-primeiras-invasoes-guiadas.md) | Juntar tudo em máquinas reais, com passo a passo | 1 semana |
| 5 | [Metodologia e cola](05-metodologia-e-cola.md) | A receita de todo CTF, comandos prontos e dicas para não travar | Consulta sempre |
| 6 | [Trilha dos 30 CTFs](06-trilha-30-ctfs.md) | 30 desafios fáceis, em ordem, para fazer sozinho | 1 a 3 meses |

Os tempos são para quem estuda cerca de 1 hora por dia. Ir mais devagar é normal.

## Como usar este guia

1. Leia os arquivos **na ordem**, de 0 a 6.
2. Em cada fase, leia a explicação primeiro e depois faça as salas do TryHackMe da lista, **na ordem em que aparecem**.
3. Marque o `[ ]` como `[x]` quando terminar uma sala (dá para editar o próprio arquivo).
4. No fim de cada fase existe um **"Teste: estou pronto?"**. Só avance se conseguir responder tudo sem olhar.
5. Deixe o arquivo [05-metodologia-e-cola.md](05-metodologia-e-cola.md) aberto do lado enquanto faz os CTFs.

## Três regras que valem para o guia inteiro

1. **Só ataque o que você tem permissão para atacar.** No TryHackMe, isso é a máquina que você mesmo ligou na sala. Nada fora disso. Explicação no [arquivo 0](00-antes-de-comecar.md#-a-regra-mais-importante-ética-e-lei).
2. **Anote tudo.** Cada IP, porta, senha, pasta e ideia. Metade dos travamentos se resolve relendo as próprias anotações.
3. **Regra dos 30 minutos.** Travou no mesmo ponto por mais de 30 minutos? Leia só a dica daquele ponto em um writeup (resolução), feche a aba e continue sozinho. Detalhes no [arquivo 5](05-metodologia-e-cola.md#-regras-de-ouro-para-não-travar).

## Seu progresso

- [ ] Fase 0: Antes de começar
- [ ] Fase 1: Terminal e Linux
- [ ] Fase 2: Redes e Web
- [ ] Fase 3: Ferramentas
- [ ] Fase 4: Primeiras invasões guiadas
- [ ] Fase 5: Li a metodologia
- [ ] Fase 6: 10 de 30 CTFs
- [ ] Fase 6: 20 de 30 CTFs
- [ ] Fase 6: 30 de 30 CTFs 🏁
