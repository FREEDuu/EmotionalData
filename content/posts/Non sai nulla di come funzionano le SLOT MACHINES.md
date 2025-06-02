
---
title: Non sai nulla di come funzionano le SLOT MACHINES
date: 2025-06-02
draft: false
tags:
  - personal
  - hashing
  - crypto
  - gambling
---
  
## Qualche dato sul volume del gioco d'azzardo in ITALIA

## Topic affrontati : 

- gambling in italia : qualche dato
- tipologie di casinò (PF, verificati)
- come i casinò dimostrano di non barare
- esempio pratico
- Prove sperimentali e simulazioni


FONTI :
- https://www.egba.eu/uploads/2025/03/250324-EGBA-European-Gaming-Market-Key-Figures-2025-Edition.pdf
- https://giocoresponsabile.info/statistiche-del-gioco/
- https://www.nomisma.it/press-area/nomisma-giovani-e-gioco-dazzardo/

Siamo uno dei mercati più grandi in Europa : 
- giochiamo moltissimo 'OFFLINE'
- giochiamo molto al Casinò e meno alla Lotteria classica rispetto agli altri paesi

![Image Description](/Pasted%20image%2020250602160416.png)

![Image Description](/Pasted%20image%2020250602160512.png)

La situazione italiana relativa al gioco d'azzardo è raccapricciante : 
- crescita rispetto agli anni precedenti (trend crescente)
- volume assoluta imbarazzantemente grande

![Image Description](/Pasted%20image%2020250602160637.png)

Tra i giovani circa il 40% dichiara di aver giocato d'azzardo l'ultimo anno :
- il 67% circa gioca online
- le scommesse sportive sono predilette
- 14% sono frequent user (almeno una volta a settimana)

Tra le motivazioni principali : 
- 46% dei ragazzi afferma infatti di aver giocato negli ultimi 12 mesi perché gli amici lo facevano già
- 32% ha dichiarato che il gioco è un’abitudine in famiglia
- 15% tenta invece la fortuna perché ha bisogno di denaro
- 12% per evasione e svago

## Chi controlla che le scommesse non siano truccate

Due mondi completamente diversi :
- Provable Fairness : il casinò può dimostrate **matematicamente** che il risultato non è stato truccato e che non potevano controllare e/o sapere prima il risultato !
- In Italia LICENZA ADM (Agenzia delle Dogane e dei Monopoli) : Un'entità esterna ed indipendente controlla e verifica la casualità dei risultati, per assicurare che nulla sia truccato

Oggi approfondiremo il mondo tecnicamente più interessante, i casinò con PF (Provable Fairness)

## L'idea dietro al PF

Vogliamo trovare un modo per dimostrare che non abbiamo barato, per farlo prima è necessario introdurre una funzione fondamentale : 

### Le funzioni di HASHING

Una funzione di hashing è una funzione, generalmente piuttosto complicata, con un obiettivo molto semplice : 
- rendere il più casuale possibile l'output di uscita

![Image Description](/Pasted%20image%2020250602163104.png)

Le proprietà fondamentali di queste funzioni sono : 
- IRREVERSIBILITÀ : dato un hash (output) è praticamente impossibile determinare l'input necessario per ottenerlo 
- facilità di calcolo : è una funzione molto semplice da applicare, senza onerosi calcoli matematici

Abbiamo quindi trovato qualcosa per oscurare un dato, in maniera manifesta : 
- fornire l'hash di un determinato segreto
- per dimostrare di aver scelto quel segreto : fornire il segreto da cui era stato calcolato l'HASH

FONTI : https://en.wikipedia.org/wiki/Commitment_scheme
## Come i casinò dimostrano di non barare

Poniamo di star giocando a sasso, carta fortice contro il casinò
Ovviamente noi dovremmo scegliere una delle 3 opzioni senza sapere cosa ha scelto il casinò 
Una volta fatta la scelta, il casinò mostra la sua e vedremo chi ha vinto e chi ha perso
Come può il casinò dimostrare di NON aver cambiato la sua scelta in base alla nostra ?
Come può dimostrare di aver giocato 'carta' ad esempio indipendentemente dalla nostra scelta ? 
Può farlo grazie alla funzione di HASH in maniera abbastanza semplice :
- Prima della nostra giocata, ci comunica un hash che sarà del tipo **HASH(CARATTERI CASUALI + SCELTA EFFETTUATA)**
- Noi facciamo la scelta
- Il casinò ci fornisce la stringa Caratteri casuali + scelta effettuata e vediamo se effettivamente corrisponde all'hash che ci ha dato inizialmente

Noi non abbiamo modo, guardando SOLO l'hash, di sapere quale scelta ha effettuato il casinò, possiamo solo confermarla all'ultimo step !

Puoi provare il tutto sulla mia piattaforma :

FONTI : https://roobet.com/fair
## Vediamo ora un caso PRATICO : [roobet](https://roobet.com/)

roobet è un casino decentralizzato che dimostra in maniera aperta di non manomettere e truccare i risultati, ed offre a chiunque la possibilità di verificare **OGNI RISULTATO USCITO**

Analizziamo qualche suo gioco e vediamo nel dettaglio come funziona : 

[Snoop Dogg](https://roobet.com/casino/game/snoops-hotbox)

È un gioco molto simile ad **Aviator** dove privia puntata, parte un moltiplicatore che può 'crashare' in qualsiasi istante : 
- se il giocatore si è ritirato prima, vince la puntata * moltiplicatore a cui si è ritirato
- altrimenti perde tutto

Come può provare che i moltiplicatori usciti siano casuali e non controllati e prevedibili dal casinò stesso ? 

andiamo per ordine : 

Il casinò utilizza due variabili fondamentali per generare i moltiplicatori :
- CLIENT SEED : il casinò lo sceglie prima ancora di saperlo, ed equivale all'HASH del prossimo blocco minato su una blockchain nota (ETH o BTC)
- SERVER SEED : lo sceglie il casinò

Procedura per generare i moltiplicatori di vincita : 
- Scelgono un SEED casuale
- Lo hashano milioni di volte consecutivamente, creando una catena di seed -> hash(seed) -> hash(hash(seed)) . . . .
- i seed da cui ricavano il moltiplicatore sono ottenuti applicando una funzione nota a tutti e che usa sia i seed generati dal casinò sia il CLIENT SEED *f*(seed + client)
- CHIUNQUE una volta generato un risultato, può verificare che sia effettivamente il risultante di quella catena di hash + client seed

I risultati sono tutti verificabili tramite un semplicissimo script python che grafica anche, dato lo storico, l'edge statistico (valore atteso negativo) che il casino ha su quello storico

Lo script grafica anche la distribuzione delle giocate e l'andamento della più famosa strategia (martingala) contro una strategia in cui invece si punta sempre la stessa quantità 

codice per verificare la validità di una catena di hash
```python
import hashlib
import hmac
import math

SALT_GLOBAL = "0xbb6bbbec33700761b7816330b017d8291ec6a775c2b582aefc8bc75103f8f3ef"
FIRST_GAME = "84351c2efd08c69ae4ae7b462207b813da40bdeaccb1350370338a0bd119710e"
LAST_GAME = "d3739ccecb01bf3b1da05e4f96300243e8d5da91192c05f3d1666ff811aa9450"

def get_result(game_hash_str: str) -> float:
"""Calcola il risultato del gioco (moltiplicatore di crash) per un dato hash di gioco."""
	key_bytes = game_hash_str.encode('utf-8')
	msg_bytes = SALT_GLOBAL.encode('utf-8')
	hm = hmac.new(key_bytes, msg_bytes, hashlib.sha256)
	h_hex = hm.hexdigest()
		
	if (int(h_hex, 16) % 33 == 0):
		return 1.0
	h_val = int(h_hex[:13], 16)
	e_val = 2**52

	if e_val == h_val:
	return float('inf')
	multiplier = math.floor((100 * e_val - h_val) / (e_val - h_val)) / 100.0
	return multiplier

def get_prev_game(hash_code_str: str) -> str:

	"""Genera l'hash SHA256 del codice hash fornito."""
	m = hashlib.sha256()
	m.update(hash_code_str.encode("utf-8"))
	return m.hexdigest()

def simulate_result(range: int = 100) -> list:

	"""Simula i risultati dei giochi a partire dall'ultimo gioco fino al primo."""
	game_hash = LAST_GAME # Start from the last game has
	results = []
	count = 0
	while FIRST_GAME != game_hash:
		count += 1
		results.append(get_result(game_hash))
		game_hash = get_prev_game(game_hash)
		return results[-range:]

print(simulate_result()) #opzionale, per printare
```

![Image Description](/Pasted%20image%2020250602182052.png)
Ecco invece com'è distribuita la probabilità dei moltiplicatori che escono : 

![Image Description](/Pasted%20image%2020250602183433.png)

Perchè è poco probabile che escano moltiplicatori ALTI : 

La funzione che determina il moltiplicatore

```python
def get_result(game_hash_str: str) -> float:
"""Calcola il risultato del gioco (moltiplicatore di crash) per un dato hash di gioco."""
	key_bytes = game_hash_str.encode('utf-8')
	msg_bytes = SALT_GLOBAL.encode('utf-8')
	hm = hmac.new(key_bytes, msg_bytes, hashlib.sha256)
	h_hex = hm.hexdigest()
	
	if (int(h_hex, 16) % 33 == 0):
		return 1.0
		
	h_val = int(h_hex[:13], 16)
	e_val = 2**52
	
	if e_val == h_val:
		return float('inf')
	multiplier = math.floor((100 * e_val - h_val) / (e_val - h_val)) / 100.0
	return multiplier
```
![Image Description](/Pasted%20image%2020250602184427.png)