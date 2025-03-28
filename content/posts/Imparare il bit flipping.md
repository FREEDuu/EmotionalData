---
title: Imparare il bit flipping
date: 2025-03-28
draft: false
tags:
  - blog
  - crypto
---

## bit flipping in AES

Il bit flipping su AES, consiste in un attacco alla modalità CBC (solitamente), con l'obbiettivo di modificare IV o blocchi del plaintext/ciphertext, con l'obiettivo di ottenere dei cambiamenti specifici nei byte cifrati/decifrati

È possibile eseguirlo quando si ha controllo sul diverse variabili in ingresso al blocco cifratore, e si avvale della conoscenza del funzionamento degli XOR nella modalità CBC

### Qualche funzione che può tornare utile

Prima di vedere il vero e proprio attacco, vediamo al volo qualche funzione che potrebbe tornare utile per eseguirlo nella pratica :

```python
from Crypto.Util.strxor import strxor

string1 = b'ciaoa'
string2 = b'pippo'

stringa3 = b'aabbccddeeffaabbcc'
stringa4 = b'123456789012345679'

stringa5 = bytes.fromhex('aabbccddeeffaabbcc')
stringa6 = bytes.fromhex('123456789012345679')

print(strxor(string1, string2))
print(strxor(stringa3, stringa4))
print(strxor(stringa5, stringa6))

"""
b'\x13\x00\x11\x1f\x0e'
b'PSQVVUS\\\\UWTTS]^^P'
b'\xb8\x8f\x9a\xa5~\xed\x9e\xed\xb5'
"""
```

da notare come `print(strxor(stringa3, stringa4))` ed `print(strxor(stringa5, stringa6))` ritornano risultati **DIVERSI** in quanto la ***b*** davanti ad stringa3 e 4 converte quella stringa in bytes carattere per carattere, mentre `bytes.fromhex('123456789012345679')` tratta la string a come stringa **ESADECIMALE**

### La funzione XOR 

La funzione XOR è una funzione booleana con seguente tabella di verità :

![Image Description](/Pasted%20image%2020250328103347.png)

## L'attacco nella pratica 

Conoscendo ora tutto il necessario, possiamo entrare nel dettaglio dell'attacco 

Requisiti :

- possibilità di manipolare IV
- modalità AES -> CBC
- conosconza del plaintext da ottenere

Funzionamento :

Analizzando come CBC decifra un ciphertext :

![Image Description](/Pasted%20image%2020250328104031.png)

Notiamo come, in particolare **L'ultimo blocco** del plaintext, dipenda solamente da ciò che esce dal blocco AES che ha decifrato l'ultimo blocco di ciphertext, XORato con l'IV

Cambiando quindi l'IV possiamo modificare **QUALSIASI CARATTERE** dell'ultimo blocco del plaintext, dobbiamo solo :

- conoscere i bytes che escono dal blocco decifratore dell'ultimo blocco -> IV XOR plaintext primo blocco
- cambiare l'IV a nostro piacimento per ottenere il desiderato plaintext
- utilizzare l'IV forgiato nella fase di decifratura

Challenge relativa su CryptoHack :

- https://aes.cryptohack.org/flipping_cookie/