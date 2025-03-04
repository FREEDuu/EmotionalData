## Breve introduzione

Un **LLM** è un modello AI specializzato nel **linguaggio**, allenato su **terabyte di dati** di testo (spesso presi dal web) e reso accessibile agli utenti tramite un'interfaccia grafica.
È un modello **statistico** in grado di prevedere il prossimo **token**, dato un contesto iniziale

## Cos'è un TOKEN

Un token è una **rappresentazione numerica** che un LLM usa per rappresentare del testo ... Facciamo un **esempio** :

**INPUT** : sono un utente  -> **OUTPUT** -> [60511, 537, 4518, 1576]

Ecco cosa veramente entra in ingresso ad un LLM ... **un lungo vettore mono-dimensionale** 

Per approfondire : https://tiktokenizer.vercel.app/

## Come dare un significato semantico ad un Token

Ad ogni Token corrisponde un particolare **Embedding**, ossia una rappresentazione vettoriale **multi-dimensionale** che lo posiziona (all'interno di uno spazio complesso, multi-dimensionale appunto), vicino alle parole semanticamente simili a lui.
È qui che avviene la comprensione **semantica** del testo !

Per approfondire : https://www.intelligenzaartificialeitalia.net/post/cosa-sono-gli-embedding-ecco-tutto-quello-che-devi-

## Come distinguere l'importanza dei Token

Il cuore pulsante di un LLM è l'architettura **Transformer**, in particolare il meccanismo di **Self-Attention**, che permette al modello di pesare l'importanza dei diversi token in una frase per generare risposte coerenti.

Per approfondire : https://smartstrategy.eu/intelligenza-artificiale/cosa-sono-i-transformer-e-come-vengono-utilizzati-nellelaborazione-del-linguaggio-naturale/

## Cosa avviene nella pratica quando usi ChatGPT

Nella pratica, durante l'utilizzo, l'utente e ChatGPT contribuiscono insieme a generare un lunga lista di token !!

![Image Description](/Pasted%20image%2020250304103754.png)

## Perchè è facile riconoscere un testo generato da un LLM

Ovviamente gli LLM hanno anche dei difetti ... il testo che generano è spesso **troppo 'perfetto'** , privo di personalità, opinioni polarizzate ed in generale anonimo
Nonostante questo, uno sguardo disattento potrebbe non rilevare un testo AI-Generated ... ma niente panico !! 
Esistono altri modelli AI che lo faranno al posto tuo :D  !! (tipo GPTZero)

Per provare GPTZero : https://gptzero.me/