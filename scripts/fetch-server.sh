#!/bin/sh
set -eu

ROOT_DIR="$(CDPATH= cd -- "$(dirname -- "$0")/.." && pwd)"
SERVER_DIR="${1:-$ROOT_DIR/server}"
CACHE_DIR="${CACHE_DIR:-$ROOT_DIR/.cache}"
PACK_VERSION="1.7.3"
PACK_FILE="cobblemon-server-${PACK_VERSION}.zip"
PACK_URL="https://www.curseforge.com/api/v1/mods/821748/files/7568760/download"
PACK_SHA256="7e2e6edfbbfbcaf716b8b251a6cb1ababbd148e01791ee14998d7792ff1a90cb"

hash_file() {
  if command -v sha256sum >/dev/null 2>&1; then
    sha256sum "$1" | awk '{print $1}'
  else
    shasum -a 256 "$1" | awk '{print $1}'
  fi
}

download() {
  destination="$1"
  url="$2"
  expected_hash="$3"

  if [ ! -f "$destination" ] || [ "$(hash_file "$destination")" != "$expected_hash" ]; then
    echo "Downloading $(basename "$destination")..."
    curl -fL --retry 3 --output "${destination}.tmp" "$url"
    actual_hash="$(hash_file "${destination}.tmp")"
    if [ "$actual_hash" != "$expected_hash" ]; then
      echo "Checksum mismatch for $(basename "$destination")" >&2
      rm -f "${destination}.tmp"
      exit 1
    fi
    mv "${destination}.tmp" "$destination"
  fi
}

mkdir -p "$CACHE_DIR" "$SERVER_DIR" "$SERVER_DIR/mods"
download "$CACHE_DIR/$PACK_FILE" "$PACK_URL" "$PACK_SHA256"

if [ ! -f "$SERVER_DIR/.cobblemon-pack-version" ] || [ "$(cat "$SERVER_DIR/.cobblemon-pack-version")" != "$PACK_VERSION" ]; then
  echo "Extracting official Cobblemon server pack ${PACK_VERSION}..."
  if command -v unzip >/dev/null 2>&1; then
    unzip -oq "$CACHE_DIR/$PACK_FILE" -d "$SERVER_DIR"
  elif command -v docker >/dev/null 2>&1; then
    docker run --rm \
      --user "$(id -u):$(id -g)" \
      --volume "$CACHE_DIR:/cache:ro" \
      --volume "$SERVER_DIR:/server" \
      alpine:3.22 unzip -oq "/cache/$PACK_FILE" -d /server
  else
    echo "Either unzip or Docker is required to extract the server pack." >&2
    exit 1
  fi
  printf '%s\n' "$PACK_VERSION" > "$SERVER_DIR/.cobblemon-pack-version"
fi

for existing in "$SERVER_DIR"/mods/modernfix-*.jar; do
  [ "$existing" = "$SERVER_DIR/mods/modernfix-fabric-5.24.3+mc1.21.1.jar" ] || rm -f "$existing"
done
for existing in "$SERVER_DIR"/mods/servercore-*.jar; do
  [ "$existing" = "$SERVER_DIR/mods/servercore-fabric-1.5.19+1.21.1.jar" ] || rm -f "$existing"
done
for existing in "$SERVER_DIR"/mods/noisium-*.jar; do
  [ "$existing" = "$SERVER_DIR/mods/noisium-fabric-2.7.0+mc1.21-1.21.1.jar" ] || rm -f "$existing"
done
for existing in "$SERVER_DIR"/mods/alternate-current-*.jar; do
  [ "$existing" = "$SERVER_DIR/mods/alternate-current-mc1.21-1.9.0.jar" ] || rm -f "$existing"
done

download "$SERVER_DIR/mods/modernfix-fabric-5.24.3+mc1.21.1.jar" \
  "https://www.curseforge.com/api/v1/mods/790626/files/6766123/download" \
  "8cea4724d32621db848c0db58d699be48076aaff767493288839ec4a83d61860"
download "$SERVER_DIR/mods/servercore-fabric-1.5.19+1.21.1.jar" \
  "https://www.curseforge.com/api/v1/mods/550579/files/8312219/download" \
  "be4540227b296d1d9435a20cb5df9bfabf9f0b150592740d2db6e8d5f8533d8d"
download "$SERVER_DIR/mods/noisium-fabric-2.7.0+mc1.21-1.21.1.jar" \
  "https://www.curseforge.com/api/v1/mods/1357563/files/7569588/download" \
  "d7e471aae3fc221f3fc31104b996b2b6f2dd592a5a9c79da4a8ef310efbea315"
download "$SERVER_DIR/mods/alternate-current-mc1.21-1.9.0.jar" \
  "https://www.curseforge.com/api/v1/mods/548115/files/5665352/download" \
  "75520a1ba75b7f1fb13508a111828c3406c509a0557c64b5b1f29862ab10d606"

if [ ! -f "$SERVER_DIR/server.properties" ]; then
  cp "$ROOT_DIR/config/server.properties" "$SERVER_DIR/server.properties"
fi

echo "Cobblemon server files are ready in $SERVER_DIR"
