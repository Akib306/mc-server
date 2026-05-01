#!/bin/sh
set -eu

SERVER_DIR="${SERVER_DIR:-/data}"
BOOTSTRAP_DIR="${BOOTSTRAP_DIR:-/bootstrap}"
MODPACK_ARCHIVE="${MODPACK_ARCHIVE:-$BOOTSTRAP_DIR/modpack.zip}"
MODS_ARCHIVE="${MODS_ARCHIVE:-$BOOTSTRAP_DIR/mods.zip}"
MODPACK_URL="${MODPACK_URL:-}"
MIN_RAM="${MIN_RAM:-8G}"
MAX_RAM="${MAX_RAM:-8G}"
JAVA_OPTS="${JAVA_OPTS:-}"

runtime_incomplete() {
  [ ! -f "$SERVER_DIR/forge.jar" ] \
    || [ ! -f "$SERVER_DIR/eula.txt" ] \
    || [ ! -f "$SERVER_DIR/server.properties" ] \
    || [ ! -d "$SERVER_DIR/mods" ] \
    || [ ! -d "$SERVER_DIR/config" ] \
    || [ ! -d "$SERVER_DIR/defaultconfigs" ] \
    || [ ! -d "$SERVER_DIR/libraries" ]
}

bootstrap_mods() {
  if [ -d "$SERVER_DIR/mods" ] && [ -n "$(ls -A "$SERVER_DIR/mods" 2>/dev/null)" ]; then
    return 0
  fi

  if [ ! -f "$MODS_ARCHIVE" ]; then
    return 0
  fi

  echo "Extracting mods archive into $SERVER_DIR"
  mkdir -p "$SERVER_DIR/mods"
  unzip -oq "$MODS_ARCHIVE" -d "$SERVER_DIR"
}

bootstrap_server() {
  if ! runtime_incomplete; then
    return 0
  fi

  tmp_archive="$BOOTSTRAP_DIR/.modpack-download.zip"

  if [ -n "$MODPACK_URL" ]; then
    echo "Downloading modpack archive from $MODPACK_URL"
    mkdir -p "$BOOTSTRAP_DIR"
    rm -f "$tmp_archive"
    curl -L --fail --output "$tmp_archive" "$MODPACK_URL"
    archive_path="$tmp_archive"
  elif [ -f "$MODPACK_ARCHIVE" ]; then
    echo "Using local modpack archive: $MODPACK_ARCHIVE"
    archive_path="$MODPACK_ARCHIVE"
  else
    echo "forge.jar was not found in $SERVER_DIR"
    echo "Provide a server pack zip at $MODPACK_ARCHIVE or set MODPACK_URL."
    exit 1
  fi

  echo "Extracting modpack archive into $SERVER_DIR"
  unzip -oq "$archive_path" -d "$SERVER_DIR"
  rm -f "$tmp_archive"

  if [ ! -f "$SERVER_DIR/forge.jar" ]; then
    echo "Bootstrap completed, but forge.jar is still missing in $SERVER_DIR"
    exit 1
  fi
}

cd "$SERVER_DIR"

bootstrap_server
bootstrap_mods

if runtime_incomplete; then
  echo "Server files are still incomplete after bootstrap."
  echo "Expected forge.jar, eula.txt, server.properties, and the mods/config/defaultconfigs/libraries directories."
  exit 1
fi

exec java $JAVA_OPTS "-Xms${MIN_RAM}" "-Xmx${MAX_RAM}" -jar forge.jar nogui
