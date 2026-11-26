# 💪 Linux Strength Training

Sala do TryHackMe para treinar o terminal do Linux: achar arquivos, lidar com nomes estranhos, identificar e quebrar hashes, decodificar base64 e abrir arquivos criptografados com o `gpg`.

Os usuários da máquina são `topson` (tasks 2 e 3) e `sarah` (tasks 4 a 7). Onde aparece `<IP>`, use o IP da máquina, que muda cada vez que você liga a sala.

## 🧰 O que a sala ensina

| Ferramenta | Para quê |
|---|---|
| `find` | Achar arquivos e pastas por nome, tipo, extensão ou data |
| `grep` | Procurar um texto dentro de arquivos |
| `tr` | Trocar caracteres (aqui, espaços por quebras de linha) |
| `nth` / `hashcat --identify` | Descobrir o tipo de um hash |
| `hashcat` | Quebrar hashes com uma wordlist |
| `base64 -d` | Decodificar texto em base64 |
| `gpg` | Criptografar e descriptografar arquivos |
| `gpg2john` + `john` | Quebrar a senha de um arquivo `.gpg` |
| `scp` | Copiar arquivos da máquina alvo para o Kali |

> 💡 Em todos os `find`, o `2>/dev/null` joga fora os erros de "Permissão negada". Sem ele, a resposta se perde no meio dos erros.

---

## Task 2: achar arquivos e pastas

Procurar arquivos pelo nome (`-type f` é arquivo):

```bash
find /home/topson -type f -name ReadMeIfStuck.txt 2>/dev/null
find /home/topson -type f -name additionalHINT 2>/dev/null
```

Procurar pastas pelo nome (`-type d` é diretório). Nome com espaço vai entre aspas:

```bash
find /home/topson -type d -name 'telephone numbers' 2>/dev/null
cd '/home/topson/corperateFiles/xch/telephone numbers'
find /home/topson -type d -name 'workflows' 2>/dev/null
```

Procurar arquivos modificados depois de uma data:

```bash
find /home/topson/workflows -type f -newermt 2016-09-12
```

A flag tem `{`, então dá para procurar por esse caractere. O `-R` procura nas subpastas, o `-i` ignora maiúsculas e o `-l` mostra só o nome do arquivo:

```bash
grep -iRl '{' /home/topson/workflows
```

O arquivo é uma linha enorme. O `tr` coloca uma palavra por linha, e o `grep` separa só a que tem a flag:

```bash
cat /home/topson/workflows/xft/eBQRhHvx | tr ' ' '\n' | grep '{'
```

🚩 **Flag:** `Flag{81726350827fe53g}`

---

## Task 3: arquivos com nome começando em `-`

Achar a dica, a pasta e o arquivo. O `*` no nome significa "qualquer coisa antes ou depois":

```bash
find /home/topson -type f -name readME_hint.txt 2>/dev/null
find /home/topson -type d -name '*march*' 2>/dev/null
find /home/topson -type f -name '*MoveMe.txt*' 2>/dev/null
```

Nomes que começam com `-` confundem os comandos, que acham que é uma opção. Usar o caminho completo resolve:

```bash
mv '/home/topson/corperateFiles/RecordsFinances/-MoveMe.txt' '/home/topson/corperateFiles/RecordsFinances/-march folder'
cd '/home/topson/corperateFiles/RecordsFinances/-march folder'
```

Executar o script. O `./` na frente também resolve o problema do `-`:

```bash
./-runME.sh
```

---

## Task 4: identificar e quebrar hashes

### Hash 1 (MD5)

Instalar o `name-that-hash` (o playbook do [Ansible](../../../ansible/README.md) já instala):

```bash
sudo apt install name-that-hash
```

Descobrir o tipo. O `nth` lista os tipos do mais provável para o menos provável:

```bash
nth -t 5d7845ac6ee7cfffafc5fe5f35cf666d
```

É MD5, que no hashcat é o modo `-m 0`:

```bash
hashcat -m 0 '5d7845ac6ee7cfffafc5fe5f35cf666d' /usr/share/wordlists/rockyou.txt
```

### Hash A (MD4)

```bash
find /home/sarah -type f -name '*hashA.txt*' 2>/dev/null
```

O próprio hashcat também identifica o tipo:

```bash
hashcat --identify 'f9d4049dd6a4dc35d40e5265954b2a46'
```

É MD4 (`-m 900`). Não está na `rockyou.txt`, por isso a wordlist da CrackStation:

```bash
hashcat -m 900 'f9d4049dd6a4dc35d40e5265954b2a46' /usr/share/wordlists/crackstation.txt
```

### Hash C (SHA-256)

```bash
find /home/sarah -type f -name '*hashC.txt*' 2>/dev/null
```

A wordlist deste hash está escondida num arquivo `.mnf`. O `-iname` ignora maiúsculas no nome:

```bash
find /home/sarah -type f -iname "*.mnf*" 2>/dev/null
```

Copiar a wordlist para o Kali (rodar **no Kali**). O `.` no fim é "a pasta atual":

```bash
scp 'sarah@<IP>:/home/sarah/system AB/db/ww.mnf' .
```

Quebrar usando o `ww.mnf` como wordlist (`-m 1400` é SHA-256):

```bash
hashcat -m 1400 'c05e35377b5a31f428ccda9724a9dfbd0c5d71dccac691228d803c78e2e8da29' ww.mnf
```

### Hash B (SHA-1)

```bash
find /home/sarah -type f -name '*hashB.txt*' 2>/dev/null
nth -t b7a875fc1ea228b9061041b7cec4bd3c52ab3ce3
```

É SHA-1. Para achar o número do modo, procure na ajuda completa do hashcat:

```bash
hashcat -hh | grep -i 'SHA1' | head -n 1
hashcat -m 100 'b7a875fc1ea228b9061041b7cec4bd3c52ab3ce3' /usr/share/wordlists/crackstation.txt
```

### Modos do hashcat usados

| Tipo | Modo |
|---|---|
| MD5 | `-m 0` |
| SHA-1 | `-m 100` |
| MD4 | `-m 900` |
| SHA-256 | `-m 1400` |

---

## Task 5: base64

```bash
find /home/sarah/ -type f -name encoded.txt 2>/dev/null
```

O arquivo é grande. Ver só as primeiras linhas decodificadas:

```bash
cat '/home/sarah/system AB/managed/encoded.txt' | base64 -d | head -n 5
```

Ir direto à parte que interessa. O `grep -o` mostra só o trecho que bate, a partir da palavra `special`:

```bash
base64 -d '/home/sarah/system AB/managed/encoded.txt' | grep -o 'special.*'
```

A dica leva a outro arquivo com um hash:

```bash
find /home/sarah/ -type f -name ent.txt 2>/dev/null
hashcat --identify bfddc35c8f9c989545119988f79ccc77
hashcat -m 900 'bfddc35c8f9c989545119988f79ccc77' /usr/share/wordlists/crackstation.txt
```

---

## Task 6: camadas de gpg

Cada camada é um arquivo criptografado, e cada um diz onde está o próximo e qual a senha. O `gpg <arquivo>` pede a senha e salva o conteúdo num arquivo sem o `.gpg`.

```bash
# camada 4
find /home/sarah/ -type f -name layer4.txt 2>/dev/null
gpg '/home/sarah/system AB/keys/vnmA/layer4.txt'

# camada 3
find /home/sarah/ -type f -name layer3.txt 2>/dev/null
gpg /home/sarah/oldLogs/2014-02-15/layer3.txt

# camada 2
find /home/sarah/ -type f -name layer2.txt 2>/dev/null
gpg /home/sarah/oldLogs/settings/layer2.txt
```

A camada 2 entrega um texto em base64 com a próxima instrução:

```bash
echo 'MS4gRmluZCBhIGZpbGUgY2FsbGVkIGxheWVyMS50eHQsIGl0cyBwYXNzd29yZCBpcyBoYWNrZWQu' | base64 -d
```

```bash
# camada 1
find /home/sarah/ -type f -name layer1.txt 2>/dev/null
gpg /home/sarah/logs/zmn/layer1.txt
```

> ⚠️ Se o `gpg` não mostrar a tela para digitar a senha, falta o `GPG_TTY`. O playbook do [Ansible](../../../ansible/README.md) já configura.

---

## Task 7: quebrar a senha de um `.gpg`

### Treino com um arquivo próprio

Criar um arquivo e criptografar com a senha `admin`:

```bash
echo 'ihan' > secret.txt && gpg --cipher-algo AES-256 --symmetric secret.txt
```

O `john` não lê o `.gpg` direto. O `gpg2john` transforma o arquivo num hash que ele entende:

```bash
gpg2john secret.txt.gpg > hash
```

Quebrar com a `rockyou.txt` e abrir o arquivo com a senha encontrada:

```bash
john --format=gpg --wordlist=/usr/share/wordlists/rockyou.txt hash
gpg secret.txt.gpg
```

### O arquivo da sala

Achar o arquivo e a wordlist, que está escondida numa pasta com nome começando em `-`:

```bash
find /home/sarah/ -type f -name personal.txt.gpg 2>/dev/null
find /home/sarah/ -type f -name data.txt 2>/dev/null
```

Copiar os dois para o Kali (rodar **no Kali**):

```bash
scp 'sarah@<IP>:/home/sarah/oldLogs/units/personal.txt.gpg' .
scp 'sarah@<IP>:/home/sarah/logs/zmn/old stuff/-mvLp/data.txt' .
```

Quebrar a senha. Leva alguns minutos:

```bash
gpg2john personal.txt.gpg > hash
john --format=gpg --wordlist=data.txt hash
```

Abrir. O `-d` mostra o conteúdo direto na tela, sem criar o arquivo `personal.txt`:

```bash
gpg -d personal.txt.gpg
```

> 🧹 No fim, apague o que foi copiado (`hash`, `data.txt`, `*.gpg`) para não ir parar no git.
