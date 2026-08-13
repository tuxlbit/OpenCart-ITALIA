#!/usr/bin/env bash
# Crea l'archivio distribuibile dell'edizione italiana di OpenCart.
# Uso: ./build.sh [versione]      (default: 4.1.0.3)

set -euo pipefail

VERSION="${1:-4.1.0.3}"
ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
OUT="$ROOT/dist/OpenCart_${VERSION}_IT.zip"

mkdir -p "$ROOT/dist"
rm -f "$OUT"

cd "$ROOT"
zip -r -q "$OUT" . \
	-x '.git/*' '.git' \
	-x 'dist/*' \
	-x 'build.sh' \
	-x 'config.php' 'admin/config.php' \
	-x 'system/storage/cache/*' 'system/storage/logs/*' 'system/storage/session/*' \
	-x 'system/storage/upload/*' 'system/storage/backup/*' 'system/storage/marketplace/*' \
	-x 'image/cache/*' \
	-x '*.DS_Store' 'Thumbs.db'

# I due file di configurazione devono esistere vuoti e scrivibili nell'archivio
TMP="$(mktemp -d)"
: > "$TMP/config.php"
mkdir -p "$TMP/admin"
: > "$TMP/admin/config.php"
(cd "$TMP" && zip -q "$OUT" config.php admin/config.php)
rm -rf "$TMP"

echo "Creato: $OUT"
unzip -l "$OUT" | tail -1
