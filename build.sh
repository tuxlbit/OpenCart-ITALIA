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
	-x '.git/*' \
	-x '.github/*' \
	-x 'docker/*' 'docker-compose.yml' 'Makefile' '.dockerignore' \
	-x 'dist/*' \
	-x 'build.sh' \
	-x 'config.php' 'admin/config.php' \
	-x 'system/storage/cache/template/*' \
	-x 'system/storage/logs/*.log' \
	-x 'system/storage/session/sess_*' \
	-x 'image/cache/catalog/*' \
	-x '*.DS_Store' 'Thumbs.db' 'desktop.ini'

# config.php e admin/config.php vanno nell'archivio vuoti e scrivibili
TMP="$(mktemp -d)"
: > "$TMP/config.php"
mkdir -p "$TMP/admin"
: > "$TMP/admin/config.php"
(cd "$TMP" && zip -q "$OUT" config.php admin/config.php)
rm -rf "$TMP"

echo "Creato: $OUT"
unzip -l "$OUT" | tail -1
