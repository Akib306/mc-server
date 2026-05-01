#!/bin/sh
set -eu

ROOT_DIR="$(CDPATH= cd -- "$(dirname "$0")" && pwd)"
BOOTSTRAP_DIR="${BOOTSTRAP_DIR:-$ROOT_DIR/bootstrap}"
MODPACK_ARCHIVE="${MODPACK_ARCHIVE:-$BOOTSTRAP_DIR/modpack.zip}"
MODS_ARCHIVE="${MODS_ARCHIVE:-$BOOTSTRAP_DIR/mods.zip}"

runtime_incomplete() {
  [ ! -f "$ROOT_DIR/forge.jar" ] \
    || [ ! -f "$ROOT_DIR/eula.txt" ] \
    || [ ! -f "$ROOT_DIR/server.properties" ] \
    || [ ! -d "$ROOT_DIR/mods" ] \
    || [ ! -d "$ROOT_DIR/config" ] \
    || [ ! -d "$ROOT_DIR/defaultconfigs" ] \
    || [ ! -d "$ROOT_DIR/libraries" ]
}

mods_missing() {
  [ ! -d "$ROOT_DIR/mods" ] || [ -z "$(ls -A "$ROOT_DIR/mods" 2>/dev/null)" ]
}

if runtime_incomplete; then
  if [ -f "$MODPACK_ARCHIVE" ]; then
    echo "Extracting server pack from $MODPACK_ARCHIVE"
    unzip -oq "$MODPACK_ARCHIVE" -d "$ROOT_DIR"
  else
    echo "Server files are incomplete and $MODPACK_ARCHIVE was not found."
    exit 1
  fi
fi

if mods_missing && [ -f "$MODS_ARCHIVE" ]; then
  echo "Extracting mods from $MODS_ARCHIVE"
  unzip -oq "$MODS_ARCHIVE" -d "$ROOT_DIR"
fi

if runtime_incomplete; then
  echo "Server files are still incomplete after setup."
  echo "Expected forge.jar, eula.txt, server.properties, and the mods/config/defaultconfigs/libraries directories."
  exit 1
fi

echo "Server files are ready."
