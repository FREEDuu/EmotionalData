---
title: Il Progetto Open Source che ha salvato il Web
date: 2025-05-29
draft: false
tags:
  - crypto
  - OpenSource
---

# Il Progetto Open Source che ha salvato il Web

## Introduzione

### Intro

Tutti noi navighiamo in rete, e per farlo, scambiamo centinaia di pacchetti, ogni giorno, con decide di server diversi, passando anche per host intermedi che non conosciamo !
Chi ci assicura che tutto il traffico di rete che noi generiamo sia accessibile solamente da noi e dal nostro destinatario finale ?
Chi ci assicura, ad esempio, che durante una transazione in cui compriamo qualcosa, i dati della nostra carta di credito sia accessibili solamente dallo shop in questione ? 

![Image Description](/traffico-pacchetti.png)

### HTTPS 

È qui che entra in gioco HTTPS, un'estensione del protocollo HTTP che, oltre a permetterci di comunicare in rete, cifra i pacchetti scambiati, permettendo una comunicazione sicura nel WEB
HTTPS sotto la scocca utilizza il protocollo TLS che, a seguito di un handshake fatto tra client e server, grazie al quale i due stabiliscono una key per la cifratura dei messaggi, avvia una comunicazione sicura

L'handshake TLS avviene in 3 fasi :

- Nel *Client Hello* il client stabilisce il primo contatto, richiedendo un certificato al server
- Nel *Server Hello* il server risponde con il certificato, che contiene una chiave pubblica, con cui il *Client* potrà cifrare la key che poi entrambi useranno per la comunicazione sicura
- Il *Client*, dopo aver controllato che il certificato *SIA VALIDO* comunica la key cifrata (tramite la chiave pubblica, e che solo il server può decifrare), con cui cifrare tutti i successivi pacchetti

![Image Description](/tls-handshake.png)

### Cosa vuol dire certificato valido ? 

Ogni volta che accediamo ad un web-server, avremo accesso al relativo certificato, di cui dobbiamo verificare la validità
Per farlo, utilizziamo una catena di FIRME->CERTIFICATI (sempre fornita dal web-server), che ci permettono di risalire ad una **CA  - Certificate Authority** che ha firmato e verificato il dominio al quale stiamo facendo accesso

Possiamo vedere la catena di certificati con **openssl** tramite il comando 

```bash 
openssl s_client -connect morrolinux.it:443 -showcerts
```

(piccola sponsor anche al tuo sito di corsi (?) :D )

![Image Description](/chain-certs.png)

Le CA sono entità sicure, che si preoccupano di firmare e verificare i certificati in rete, la cui autorevolezza è **facilmente verificabile**
Per farlo, i browser moderni, accedono ad una lista di **CA Authority** affidabili, ad esempio, nei browser chromium-based, la lista è accessibile in `chrome://system/` nella sezione `chrome_root_store`

Se il certificato fornito dal sito che stiamo visitando, è firmato da una *CA* presente nella lista del nostro browser, allora il sito sarà considerato affidabile
Se invece non c'è, il browser ci darà quel famoso warning che abbiamo visto tutti almeno una volta nella vita : 

![Image Description](/invalid-cert.png)

### Come posso ottenerlo ?

Il problema ora è come ottenere la firma di un CA autorevole per il nostro sito, ed è proprio qui che interviene il progetto Open Source che ha salvato il WEB ... **Let's Encrypt** !!
Let's encrypt fornisce un sistema **gratuito ed automatico** per la firma del nostro certificato, che permetterà a qualsiasi utente, di accedere in maniera sicura e senza warning di alcun tipo
Senza Let's encrypt, ci dovremmo affidare a CA costose e molto lente, come si faceva in passato, rendendo molto più difficile pubblicare qualcosa in rete (con comunicazione cifrata) ! 

Ma com'è possibile rendere automatica e gratuita la firma di oltre 300 mila certificati all'ora ?
La Internet Security Research Group (ISRG), l'associazione no-profit, responsabile della sicurezza di oltre 500 milioni di siti, e che si occupa di mantenere ed aggiornare Lets Encrypt, è arrivata a queste cifre grazie ad ACME
ACME (Automated Certificate Management Environment) è un protocollo completamente automatico il cui obiettivo è stabilire se, chi richiede la firma di un determinato certificato, relativo ad un determinato dominio, è effettivamente il proprietario di quel dominio

FONTI : https://letsencrypt.org/2025/01/30/scaling-rate-limits/
## Come Funzione Let's Encrypt

### La challenge 'ACME' da superare

Per stabilire la proprietà di un dominio il protocollo pretende dal richiedente di superare una 'challenge' che solo il proprietario del server potrebbe superare : posizionare uno specifico file, contenenti specifiche informazioni, in un preciso PATH del server
Ma formalizziamo meglio i vari step del protocollo : 
- il *Client* (che vorrebbe la firma del suo certificato), genera il certificato e comunica la sua chiave pubblica al server ACME, le successive comunicazioni saranno firmate dal client utilizzando questo certificato (attestandone la validità)
- Il *Client* invia una richiesta (ordine) specificando uno o più nomi di dominio (identificatori) per cui desidera il certificato (es. `example.com`, `www.example.com`
- Il *Server ACME* controlla se, per ogni dominio specificato, è accessibile tramite una richiesta HTTP uno specifico token precedentemente comunicato e comunica il successo della challenge al Client

![Image Description](/acme-challenge.png)


### DEMO 

Mettiamo subito le mani in pasta per vedere come funziona nel dettaglio 
Useremo un server pebble che simulerà il server ACME per la validazione della challenge e del certificato

per runnare il server pebble clona la repo e runna il container :

```bash
git clone https://github.com/letsencrypt/pebble.git
cd pebble 
docker compose up
```

visita `https://0.0.0.0:14000/dir` per assicurarti che tutti funzioni correttamente, questa pagina espone i servizi principali di un server ACME :

```json
{
   "keyChange": "https://0.0.0.0:14000/rollover-account-key",
   "meta": {
      "externalAccountRequired": false,
      "profiles": {
         "default": "The profile you know and love",
         "shortlived": "A short-lived cert profile, without actual enforcement"
      },
      "termsOfService": "data:text/plain,Do%20what%20thou%20wilt"
   },
   "newAccount": "https://0.0.0.0:14000/sign-me-up",
   "newNonce": "https://0.0.0.0:14000/nonce-plz",
   "newOrder": "https://0.0.0.0:14000/order-plz",
   "renewalInfo": "https://0.0.0.0:14000/draft-ietf-acme-ari-03/renewalInfo",
   "revokeCert": "https://0.0.0.0:14000/revoke-cert"
}
```

Dato che la demo sarà in locale, dobbiamo anche aggiungere un paio di redirect in `/etc/hosts/` tramite :

```bash
sudo sh -c 'echo "127.0.0.1 pebble" >> /etc/hosts'

sudo sh -c 'echo "127.0.0.1 test.localhost" >> /etc/hosts'
```

**i due script python li trovi sul mio GH **

Ora puoi runnare il server web tramite lo script python `python3 simple_server.py`
e controlla che il server è up : `http://test.localhost:5000`

Adesso possiamo richiedere un certificato tramite lo script python `get_certificate.py` che crea i vari certificiati nella cartella `/certificates`

Bene ! il server pebble ha firmato il nostro certificato nel file `certificates/pebble_signed_demo.pem` e che possiamo leggere con openssl :

```bash
openssl x509 -in certificates/pebble_signed_demo.pem -text -noout
```

certificato firmato ( Subject: CN = test.localhost  ,  Issuer: C = US, O = Pebble CA Demo, CN = Pebble Intermediate CA Demo )

```
Certificate:
    Data:
        Version: 3 (0x2)
        Serial Number:
            2e:03:c9:bd:65:60:e3:0e:ed:bb:af:57:6b:46:1a:48:b7:3b:96:ce
        Signature Algorithm: sha256WithRSAEncryption
        Issuer: C = US, O = Pebble CA Demo, CN = Pebble Intermediate CA Demo
        Validity
            Not Before: May 23 07:45:28 2025 GMT
            Not After : Aug 21 07:45:28 2025 GMT
        Subject: CN = test.localhost 
        Subject Public Key Info:
            Public Key Algorithm: rsaEncryption
                Public-Key: (2048 bit)
                Modulus:
                    00:c9:21:ad:29:79:d6:a0:32:41:1c:6d:a7:55:f3:
                    88:dc:8c:b8:6c:cc:9e:84:05:42:c5:31:1d:72:c1:
                    05:02:e3:35:4b:10:19:92:b1:d5:16:89:1d:f7:b2:
                    da:17:98:fa:b2:c1:14:f0:b3:65:79:3c:ff:5b:da:
                    b1:b9:66:e9:7b:12:34:ec:d6:e7:e8:8b:f1:38:00:
                    fb:86:19:ac:f7:9c:9a:01:69:9a:20:4c:ab:6e:8e:
                    f9:f4:a7:e1:ef:70:08:06:2c:c2:71:09:58:b4:4d:
                    58:a7:a2:e9:34:15:6b:8d:15:b2:19:64:db:7f:27:
                    7e:0f:68:39:0f:9c:5f:ed:e8:eb:b6:b9:53:19:d7:
                    5d:f5:45:94:24:9c:c5:33:a6:2f:f2:4d:d1:21:fb:
                    6a:36:5e:e0:b7:5b:2a:d9:02:66:52:73:be:a1:c2:
                    34:89:bc:fe:d5:fc:14:86:b5:01:c0:b4:87:7b:53:
                    91:6e:a6:1f:65:6c:24:65:00:47:ed:90:32:d9:bd:
                    5b:fb:05:97:78:67:2d:48:ba:a8:f6:29:fc:0f:5d:
                    66:cf:61:93:3c:4f:e5:de:9b:3a:9c:5b:45:d1:a8:
                    d7:db:4f:91:ec:f3:8b:ef:f6:1f:fd:48:9b:52:96:
                    c2:d8:af:00:32:85:db:f5:f6:74:eb:31:36:4a:3e:
                    7b:81
                Exponent: 65537 (0x10001)
        X509v3 extensions:
            X509v3 Subject Alternative Name: 
                DNS:test.localhost
    Signature Algorithm: sha256WithRSAEncryption
    Signature Value:
        52:77:18:3b:3f:ad:ce:67:8e:91:55:0f:c2:8f:3c:94:66:27:
        4f:e1:82:11:14:e1:6d:af:1f:85:ca:09:97:c3:ea:db:9a:c8:
        48:bb:c3:03:3a:70:d0:1f:33:fe:2d:f2:f1:76:3b:20:da:7f:
        1d:7b:04:1e:42:89:45:3f:e2:f0:c5:a4:95:84:3c:c2:b8:d5:
        bc:d2:3f:1a:e7:3c:15:6c:80:eb:70:92:ac:cd:62:45:64:94:
        20:9b:07:c6:8e:91:a3:2b:dd:d2:4f:8e:eb:6b:80:2c:70:c8:
        60:5d:08:b5:eb:31:f5:01:ca:71:07:42:89:e2:20:a5:68:03:
        ef:31:ce:59:da:e5:bc:d1:5d:41:ac:94:fd:74:dc:13:96:fa:
        fa:8b:0d:e2:10:a9:07:c7:12:6c:76:36:96:7f:61:d7:59:76:
        95:8a:84:fd:26:c4:1e:18:f8:13:71:b9:ff:27:40:7a:2b:0b:
        05:27:a2:56:e5:3b:74:da:ec:3f:d0:bc:5f:70:ac:4b:93:d7:
        40:26:5f:f5:50:fa:6f:84:18:4e:af:77:48:23:57:cd:3d:ab:
        a5:83:48:2c:4b:88:6d:15:db:2d:28:1d:02:2a:a2:b9:8e:b2:
        06:e7:10:1e:78:58:1c:15:62:e5:bc:fe:9d:b7:1c:e7:9e:2f:
        fe:01:20:7d
```

In un contesto reale, Lets Encrypt (al posto di pebble) avrebbe firmato il nostro certificato, rendendo la connessione HTTPS valida e sicura :D
## Perchè tutto questo è fondamentale

Partiamo subito dal punto più pratico per molti: se hai un sito web, **senza HTTPS sei penalizzato dai motori di ricerca**. Google e gli altri giganti del web hanno reso la sicurezza una priorità assoluta. Questo significa che i siti senza certificato HTTPS vengono declassati nei risultati di ricerca, rendendoti di fatto invisibile a potenziali visitatori o clienti. 

Ma la penalizzazione di Google è solo la punta dell'iceberg. Pensate all'esperienza dell'utente. Quando qualcuno visita il vostro sito e vede la scritta **"Sito non sicuro"** nella barra degli indirizzi del browser, cosa succede? Si innesca immediatamente una sensazione di sfiducia. E per una buona ragione!

Senza HTTPS, chiunque può **intercettare il traffico** tra voi e il sito

**MOSTRARE LA DIFFERENZA TRA TRAFFICO HTTP E HTTPS CON WIRESHARK**

Fortunatamente, grazie a progetti come **Let's Encrypt**, abbiamo assistito a una vera e propria **democratizzazione della sicurezza**. Prima, ottenere un certificato HTTPS era costoso e complicato. Ora, con Let's Encrypt, tutto è cambiato.

Questa accessibilità ha portato ad un **aumento esponenziale dell'adozione di HTTPS** su tutto il web. Siamo passati da una situazione in cui la maggior parte dei siti non era sicura, a una dove la maggior parte lo è. Ed è per questo che Let's Encrypt ha letteralmente "salvato il web"