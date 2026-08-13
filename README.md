# OpenCart 4.1.0.3 — Edizione Italiana

[![OpenCart](https://img.shields.io/badge/OpenCart-4.1.0.3-1e88e5)](https://www.opencart.com/)
[![PHP](https://img.shields.io/badge/PHP-8.1%2B-777bb4)](https://www.php.net/)
[![Licenza](https://img.shields.io/badge/licenza-GPL--3.0-green)](LICENSE)
[![Versione](https://img.shields.io/badge/versione-4.1.0.3-blue)](CHANGELOG.md)
[![Lingua](https://img.shields.io/badge/lingua-italiano-red)](https://www.opencartitalia.it)

**OpenCart 4.1.0.3 completamente in italiano**: pannello di amministrazione, vetrina, estensioni di
serie e procedura di installazione. Si scarica, si installa e si lavora in italiano dal primo
minuto — senza pacchetti lingua da comprare, senza schermate in inglese e senza dover sistemare a
mano paese, valuta e aliquota IVA.

Sviluppato da **OpenCart ITALIA by SOLOSOLUZIONI** — [opencartitalia.it](https://www.opencartitalia.it)
· [solosoluzioni.it](https://www.solosoluzioni.it)

---

## Caratteristiche

- **Pannello di amministrazione in italiano** — 120 file di lingua, terminologia coerente in tutto
  il pannello (Cruscotto, Progettazione, Rapporti, Giacenza…).
- **Vetrina in italiano** — 86 file di lingua.
- **Estensioni di serie tradotte** — 62 file lato amministrazione e 33 lato vetrina: metodi di
  pagamento e spedizione, moduli, temi e rapporti parlano italiano come il resto del pannello.
- **Installazione guidata interamente in italiano** — quattro passaggi, nessun selettore di lingua,
  nessuna schermata inglese. Disponibile anche da riga di comando.
- **Impostazioni predefinite per l'Italia** — paese Italia, zona Roma, **euro come valuta base**,
  aliquota unica **IVA 22%**, geo zone già puntate sull'Italia.
- **Dati geografici corretti** — 253 paesi e 4.066 zone con la grafia ufficiale, comprese le
  110 province italiane.
- **Inglese incluso come riserva** — la lingua `en-gb` è presente e si attiva quando serve da
  *Sistema → Localizzazione → Lingue*.

## Requisiti

- PHP **8.1+** con le estensioni `mysqli`, `gd`, `curl`, `openssl`, `zlib`, `zip`, `mbstring`
- MySQL 5.7+ oppure MariaDB 10.3+
- Apache o Nginx

## Installazione

### Da browser

1. Scarica l'archivio dalla [pagina delle release](https://github.com/tuxlbit/OpenCart-ITALIA/releases)
   e copia i file sul server web.
2. Verifica che `config.php` e `admin/config.php` siano scrivibili: sono inclusi vuoti e la
   procedura di installazione li compila.
3. Apri `http://tuodominio/install/` e segui i quattro passaggi.
4. A installazione conclusa rinomina o elimina la cartella `install/`.

### Da riga di comando

```bash
php install/cli_install.php install \
    --username    admin \
    --password    password \
    --email       tua@email.it \
    --http_server http://tuodominio/ \
    --language    it-it \
    --db_driver   mysqli \
    --db_hostname localhost \
    --db_username utente \
    --db_password segreta \
    --db_database opencart \
    --db_port     3306 \
    --db_prefix   oc_
```

## Provalo con Docker

Nel repository c'è un ambiente Docker pronto: Apache, PHP-FPM e MariaDB in contenitori
separati, con l'installazione italiana già fatta al primo avvio.

```bash
make init     # prepara docker/.env.docker
make build    # costruisce le immagini
make up       # avvia i servizi
```

Negozio su `http://localhost:8080/`, pannello su `http://localhost:8080/admin/`,
credenziali predefinite `admin` / `admin123` (si cambiano in `docker/.env.docker` prima
del primo avvio). Servono Docker, Docker Compose e `make`; su Windows conviene usare WSL 2.

| Comando | Cosa fa |
|---|---|
| `make up` | Avvia i servizi |
| `make down` | Ferma i contenitori (`options="-v"` cancella anche il database) |
| `make logs options="php"` | Segue i log di un servizio |
| `make php` | Apre una shell nel contenitore PHP |
| `make mysql` | Apre una shell nel contenitore MariaDB |
| `make up profiles="adminer"` | Avvia anche Adminer su `http://localhost:8081/` |
| `make help` | Elenco completo dei comandi |

Sono disponibili come servizi facoltativi anche `redis` e `memcached`. Per vedere la
procedura di installazione italiana invece di saltarla, imposta `AUTO_INSTALL=0` in
`docker/.env.docker` e apri `http://localhost:8080/install/`.

## Struttura

| Cartella | Descrizione |
|---|---|
| `admin/` | Pannello di amministrazione (lingue `it-it`, `en-gb`) |
| `catalog/` | Vetrina (lingue `it-it`, `en-gb`) |
| `extension/opencart/` | Estensioni di serie (lingue `it-it`, `en-gb`) |
| `install/` | Procedura di installazione, solo in italiano |
| `system/` | Framework OpenCart |
| `docker/` | Ambiente Docker: immagini Apache e PHP, configurazioni, avvio |

## Dopo l'installazione

Il negozio parte con nome *Your Store* e dati di contatto di esempio: la prima cosa da fare è
aprire *Sistema → Impostazioni*, modificare il negozio e compilare nome, indirizzo, contatti e
**Meta tag Titolo** nella scheda *Negozio*. Da lì si controllano anche valuta, unità di misura
e opzioni fiscali.

## Assistenza

Domande, segnalazioni e richieste di personalizzazione: [opencartitalia.it](https://www.opencartitalia.it).
Per bug e proposte relative a questa distribuzione usa le
[issue del repository](https://github.com/tuxlbit/OpenCart-ITALIA/issues).

## Licenza

[GPL-3.0](LICENSE), come OpenCart. OpenCart è un marchio di OpenCart Ltd.; questa è una
ridistribuzione localizzata in italiano, non un prodotto ufficiale OpenCart Ltd.
