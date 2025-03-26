---
title: Capire un cifrario asimmetrico (RSA)
date: 2025-03-26
draft: false
tags:
  - personal
  - blog
  - crypto
---

## Cos'è un cifrario asimmetrico

Un cifrario simmetrico è un particolare **algoritmo** di **cifratura** in cui la chiave utilizzata per cifrare il testo in chiaro (plaintext) è **diversa** dalla chiave utilizzata per decifrare il testo cifrato (ciphertext).

Differentemente da **AES**, avremo bisogno di due *chiavi distinte* per cifrare e decifrare il messaggio

Scopo :
- disaccoppiare in due chiavi distinte le funzioni di cifratura/decifratura, spostando la segretezza su una sola chiave (quella di decifratura), e rendendo di pubblico dominio la chiave pubblica (quella di cifratura)

Vantaggi :
- elimina il problema dello scambio della chiave simmetrica

Svantaggio :
- computazionalmente più pesante, avremo bisogno di fare dei calcoli più lenti e complessi di quelli in AES

## L'idea di base 

L'idea di base è molto semplice ...mi servono due chiavi (due numeri) candidati per essere le rispettive chiavi (pubblica e privata).

 ### Come le scelgo ?

Proprietà della chiave pubblica :
- deve essere accessibile **da tutti**
- deve ***contenere*** informazioni della chiave privata ... ma solo *noi* dobbiamo essere in grado di recuperarla e non gli *attaccanti*

### L'inverso modulare

L'inverso modulare è quel numero tale che
$$
 d * e = 1 (modulo - phi)
$$
La soluzione è unica
Questo numero esiste $<=>$ ***e*** e ***phi*** sono coprimi
 (Perchè  ?? Ripassare -> Teoria dei numeri + Algebra lineare )

con :
- d numero intero (sarà la nostra chiave privata)
- e numero intero (sarà parte della nostra chiave pubblica)
- phi numero intero (ricavato da un'altro *pezzo* di chiave pubblica)

#### Perchè questo approccio è interessante

L'inverso modulare è interessante perchè attraverso una definizione abbastanza banale, stiamo mettendo in relazione chiave pubblica e privata ... 
La nostra chiave pubblica sarà in realtà **una coppia di numeri**, il primo descritto sopra *e* ed un secondo numero che condurrà al nostri *phi* con cui poi risolvere l'equazione dell'inverso modulare 

È rimasto però un problema banale da comprendere :
- Se la relazione è così banale e la chiave è pubblica ... la chiave privata ***d*** non possono ottenerla tutti ?

### Cos'è precisamente *phi* (Toziente di Eulero)

il **Toziente di Eurlero** è quella funzione che ritorna, dato un intero N,
il numero di **interi compresi** tra 1 ed N, che sono coprimi con N

Esempio pratico :

- phi(5) = 4 (i numeri coprimi con 5 sono 4 -> 1,2,3,4)
- phi(8) = 4(i numeri coprimi con 8 sono 4-> 1,3,5,7)

#### Un numero primo p ha come phi(p) sempre p-1

## Perchè la funzione di Eulero è interessante

A prima vista può sembrare anche questa una funzione abbastanza banale e poco interessante, ma in realtà nasconde il segreto fondamentale dietro a tutto RSA !

Ricapitolando :
- abbiamo una funzione (l'inverso modulare) che associa correttamente le due chiavi
- abbiamo bisogno di un modo per ricavare *phi* da un numero pubblico, senza che gli altri ne siano capaci

Notiamo subito una cosa ... per numeri molto grandi e ***NON PRIMI*** calcolare phi diventa computazionalmente difficile ... molto difficile

Sappiamo inoltre che, i numeri primi hanno un *phi* il più grande possibile 

Cosa succederebbe se scegliessimo due *numeri primi* molto grandi (che chiameremo p e q) e come chiave pubblica scegliessimo il prodotto di questi due ?
$$
 p * q = n
$$
dove p,q sono due primi, interi, **molto grandi** e n anch'esso primo molto grande

#### Proprietà di n
Il numero che abbiamo ottenuto in questo modo, ha alcune interessanti proprietà ... :

- riconduce a *phi* in maniera elementare (se conosciamo p e q)
- per chi non conosce p e q, nasconde *phi* in maniera efficace, in quanto calcolare phi(n) per numeri così grandi è molto complesso
- nasconde p e q in maniera altrettanto efficace in quanto scomporre in fattori primi n è molto complesso (e lento, essendo n molto grande)

## RSA in formule

Ora che abbiamo una discreta base teorica, possiamo passare alle formule vere e proprie per l'applicazione di RSA

- Step 1 : scegliere due primi p e q ... ottenendo n (abbastanza grandi)

Matematichese :
$$
p * q = n
$$
Pythoniano :
```python
from Crypto.Util.number import getPrime

# Genera due numeri primi di 512 bit
p = getPrime(512)
q = getPrime(512)

n = p * q
"""
n : 134333369727773603748609461205484317864667810917453186183810037016260944958423276137167055339911724718234536919500886700479776184847784217176736682668421628514007658932666418785980205141981616923881982533055508154526236600054369053571972283481209913798569603696122840975526279163472857654658196779815267488371
"""
```


- Step 2 : scegliere ***e*** (65337 è l'esponente standard ), basta che sia **abbastanza grande** e soprattutto **coprimo** con phi(n) ... calcolando phi(n)

Matematichese :
$$
e = 65537  
$$
$$
phi(n) = (p-1) * (q-1)
$$
Pythoniano :
```python
from Crypto.Util.number import getPrime

p = getPrime(512)
q = getPrime(512)
n = p * q

phi = (p-1)*(q-1)
e = 65537

"""
phi : 165075765604531742825943797848654728711426117379912806755380115128241952297441464392770314697504795453929347257648550691957272264907556334094141254608504024261346521975405947632469201789431749597481910365264401575391192814419776767471578042161547963279278070379993418397465599185130008129073930782576533235200
"""

```

Step 3 : Calcolare l'inverso modulare di e modulo phi, ottenendo così la **chiave privata**

Matematichese : 
$$
 d * e == 1 (mod-phi)
$$
Pythoniano : 
```python
from Crypto.Util.number import getPrime

p = getPrime(512)
q = getPrime(512)
n = p * q

phi = (p-1)*(q-1)
e = 65537

d = pow(e, -1, phi)

"""
d:
105774093829104142957147191101434751506699604546154130841926836378068400784671799065080951208655542578096554624385362243516976257637683100483477731427732399080690128843728060994032753763299728409957455516609072579378622104040844877520191624047213924376771351727416934898482274884038365798405859354109777021845
"""
```

Siamo ora in grado di cifrare e decifrare messaggi attraversi semplici formule di potenze modulari 

### Formula cifratura :

Mathematichese :
$$
c = m^e (mod-n)
$$
Pythoniano :
```python
messaggio = 1234567893214235252334132

c = pow(messaggio, e, n)
"""
c :
48849769123015244680792235274270549304925480427770106744481073872881740942521344432142769064721482955781647523811245949646705646620511113458950730047323453466685888878269548132276435866880013773063442236453124037134898562301556863533189180892005757670021034640448172835900987394791567279583089825905792603419
"""
```

### Formula decifratura :

Mathematichese :
$$
m = c^d (mod-n)
$$
Pythoniano :
```python
messaggio  = pow(c, d, n)
"""
messaggio :
1234567893214235252334132
"""
```

## Alcune conversioni utili in Python

Se volessi decifrare un messaggio generico mi basta convertire il messaggio in un intero ... Come ? Perchè ? (ripassare conversione ASCII) ogni carattere -> 1 byte -> numero base decimale

Per gestire facilmente le conversioni intero -> bytes e bytes -> interi utilizziamo pycryptodome

```python
from Crypto.Util.number import getPrime, long_to_bytes, bytes_to_long

p = getPrime(512)
q = getPrime(512)
n = p * q
phi = (p-1)*(q-1)
e = 65537
d = pow(e, -1, phi)

messaggio = "messaggio segretissimo !"
messaggio = bytes_to_long(messaggio.encode())

c = pow(messaggio, e, n)
messaggio = pow(c, d, n)

print("c: ", c)
print("messaggio: ", long_to_bytes(messaggio))

```

ho bisogno di  `messaggio.encode()` perchè la funzione `bytes_to_long` prende come input *bytes* e non stringhe !

Altre conversioni utili ... :

```python
from Crypto.Util.number import bytes_to_long
import binascii

messaggio = "messaggio segretissimo !"
messaggio = binascii.hexlify(messaggio.encode())

print("messaggio in byte: ", messaggio)
print("messaggio in esadecimale: ", messaggio.decode())
print("messaggio in intero: ", bytes_to_long(messaggio))
print("messaggio in stringa: ", bytes.fromhex(messaggio.decode()).decode())

```