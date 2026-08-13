# Diario delle modifiche

Il numero di versione segue quello di OpenCart su cui è basata la distribuzione.

## [4.1.0.3] — 2026-08-13

Prima versione pubblica di **OpenCart ITALIA**, l'edizione italiana di OpenCart 4.1.0.3.

### Traduzione

- Pannello di amministrazione in italiano: 120 file di lingua `it-it`, terminologia uniforme
  (Cruscotto, Progettazione, Rapporti, Giacenza, Buono sconto…).
- Vetrina in italiano: 86 file di lingua `it-it`.
- Estensioni di serie in italiano: 62 file lato amministrazione e 33 lato vetrina.
- Procedura di installazione interamente in italiano, dalla licenza alla schermata finale.
- Lingua `en-gb` inclusa come riserva, attivabile da *Sistema → Localizzazione → Lingue*.

### Installazione

- Installazione forzata in italiano: nessun selettore di lingua, nessun passaggio in inglese.
- Installazione da riga di comando con `install/cli_install.php`.

### Dati predefiniti

- Paese Italia, zona Roma, lingua e valuta del negozio già impostate su italiano ed euro.
- Euro come valuta base (`1,00000000`), le altre valute espresse in euro.
- Aliquota unica **IVA 22%** applicata alla geo zona Italia.
- Geo zone *Zona IVA Italia* e *Spedizione in Italia* riferite all'Italia (`country_id` 105).
- 253 paesi e 4.066 zone con la grafia ufficiale, comprese le 110 province italiane.
- Dump SQL compatibile anche con la modalità MySQL `NO_BACKSLASH_ESCAPES`.

### Ambiente Docker

- Ambiente Docker incluso nel repository: Apache, PHP-FPM e MariaDB in contenitori separati,
  con `Makefile` (`make init`, `build`, `up`, `down`, `logs`, `php`, `mysql`).
- Installazione italiana automatica al primo avvio, disattivabile con `AUTO_INSTALL=0` per
  vedere la procedura guidata.
- Servizi facoltativi Adminer, Redis e Memcached, avviabili con `make up profiles="..."`.
- Impostazioni raccolte in `docker/.env.docker`, creato da `make init`.
- `.gitattributes` impone terminazioni di riga LF a tutti i file di testo, anche su Windows, e
  l'immagine PHP normalizza comunque lo script di avvio: senza questo il contenitore PHP si
  fermava con `exec /usr/local/bin/docker-opencart-entrypoint: no such file or directory`.

### Marchio

- Piè di pagina del pannello: *OpenCart ITALIA by SOLOSOLUZIONI*, con i collegamenti a
  opencartitalia.it e solosoluzioni.it.
- Menu *Guida* del pannello: Sito, Documentazione e Assistenza rimandano a opencartitalia.it.
- Titolo del pannello e piè di pagina della vetrina (*Realizzato con OpenCart ITALIA*) allineati
  al marchio, sia in italiano sia in inglese.
- I collegamenti funzionali al marketplace OpenCart restano invariati: servono a ottenere la
  chiave API e a installare le estensioni.

### Qualità

- Tutti i file PHP verificati con `php -l`.
- Installazione completa provata su MariaDB 10.11 con `cli_install.php` e controllo del database
  risultante; procedura web verificata da browser.

### Progetto

- `README.md`, `CHANGELOG.md`, `build.sh` per l'archivio distribuibile, `.gitignore` e
  `.gitattributes`.
- `config.php` e `admin/config.php` inclusi vuoti: servono alla procedura di installazione,
  che li compila al primo avvio.
