#!/bin/sh
set -eu

ROOT_DIR="$(CDPATH= cd -- "$(dirname -- "$0")/.." && pwd)"
OUTPUT_DIR="$ROOT_DIR/artifacts"
OUTPUT_FILE="$OUTPUT_DIR/Cobblemon-Optimized-1.7.3-CurseForge.zip"

mkdir -p "$OUTPUT_DIR"
rm -f "$OUTPUT_FILE"

(
  cd "$ROOT_DIR/client"
  zip -qr "$OUTPUT_FILE" manifest.json modlist.html overrides
)

unzip -tq "$OUTPUT_FILE" >/dev/null
echo "Created $OUTPUT_FILE"
