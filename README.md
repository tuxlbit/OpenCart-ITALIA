# OpenCart 4.1.0.3 — Edizione Italiana

Distribuzione di OpenCart 4.1.0.3 completamente in italiano: pannello di amministrazione,
vetrina, estensioni e procedura di installazione.

Ricostruita a partire dal pacchetto `OpenCart_4.1.0.3_ITA.zip` correggendone i difetti
(vedi *Correzioni applicate*).

## Contenuto

| Cartella | Descrizione |
|---|---|
| `admin/` | Pannello di amministrazione (lingue: `it-it`, `en-gb`) |
| `catalog/` | Vetrina (lingue: `it-it`, `en-gb`) |
| `extension/opencart/` | Estensioni di serie (lingue: `it-it`, `en-gb`) |
| `install/` | Procedura di installazione, **solo in italiano** |
| `system/` | Framework OpenCart |

## Installazione

### Da browser

1. Copiare tutti i file sul server web.
2. Creare due file vuoti `config.php` e `admin/config.php` e renderli scrivibili
   (non sono nel repository perché contengono la configurazione del singolo negozio).
3. Aprire `http://tuodominio/install/` e seguire i quattro passaggi.
4. A installazione conclusa rinominare o eliminare la cartella `install/`.

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

## Correzioni applicate rispetto al pacchetto originale

### 1. File di lingua

I file `it-it` sono stati sostituiti integralmente con quelli dell'installazione di
riferimento (progetto `OpenCart_Claude`), con traduzioni coerenti e tutti i file
verificati con `php -l`.

- `admin/language/it-it` — 120 file
- `catalog/language/it-it` — 86 file
- `extension/opencart/admin/language/it-it` — 62 file (**assenti nel pacchetto originale**)
- `extension/opencart/catalog/language/it-it` — 33 file (**assenti nel pacchetto originale**)

Aggiunta anche la lingua `en-gb` come riserva per pannello, vetrina ed estensioni
(non registrata nel database: la si può attivare da *Sistema > Localizzazione > Lingue*).
Rimossa la lingua `fr-fr` dalle estensioni.

### 2. Procedura di installazione solo in italiano

- `system/config/install.php`: lingua predefinita `it-it` (era `en-gb`, ma i file
  `en-gb` dell'installer non erano nemmeno presenti nel pacchetto).
- `install/controller/startup/install.php`: il parametro `?language=` viene ignorato,
  la lingua è forzata a `it-it`.
- `install/controller/common/header.php` e `install/view/template/common/header.twig`:
  rimosso il menu a tendina di selezione della lingua; `<html lang="it">`.
- Rimosso `install/opencart-en-gb.sql`: resta solo il dump italiano.
- Tradotta la stringa `text_step_1`, rimasta in inglese.

### 3. Zone geografiche e fiscalità (`install/opencart-it-it.sql`)

- **Nomi delle zone** — nel pacchetto originale i nomi di tutte le zone del mondo erano
  stati tradotti automaticamente, con esiti errati (`Puke` → *Vomito*, `Peqin` → *Pechino*,
  `Encamp` → *Accamparsi*, `Mat` → *Stuoia*…). Le tabelle `country`, `zone` e
  `zone_description` sono state ripristinate identiche al dump ufficiale OpenCart:
  i nomi propri restano nella grafia originale e le 110 province italiane sono corrette.
- **Geo zone** — erano state rinominate *Zona IVA Italia* / *Spedizione in Italia* ma
  contenevano ancora le contee del Regno Unito (`country_id` 222). Ora entrambe puntano
  all'Italia (`country_id` 105, tutte le zone).
- **IVA** — l'aliquota era quella britannica (20%) ed era presente una tassa ecologica
  inesistente in Italia. Ora c'è una sola aliquota `IVA (22%)` sulla zona Italia.
- **Valute** — l'euro aveva un tasso di 0,7846 pur essendo la valuta predefinita del
  negozio. Ora `EUR = 1,00000000` e le altre valute sono ricalcolate su base euro.
- **Escape SQL** — gli apostrofi con backslash (`\'`) sono stati convertiti in apostrofi
  doppi (`''`), compatibili anche con la modalità `NO_BACKSLASH_ESCAPES`.

## Verifiche eseguite

- `php -l` su tutti i file PHP modificati.
- Installazione completa via `cli_install.php` su MariaDB 10.11: esito positivo.
- Controllo sul database installato: lingua `it-it`, valuta `EUR`, paese `Italia` (105),
  zona `Roma` (3924), geo zone sull'Italia, aliquota IVA 22%, 4.066 zone e 253 paesi.
- Installer web aperto da browser: interfaccia in italiano, nessun selettore di lingua.

## Credenziali e impostazioni predefinite del negozio

Il negozio viene creato con paese Italia, zona Roma, valuta euro e lingua italiana;
nome del negozio e dati di contatto vanno personalizzati in *Sistema > Impostazioni*.
