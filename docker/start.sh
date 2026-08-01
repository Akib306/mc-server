#!/bin/sh
set -eu

MINECRAFT_VERSION="${MINECRAFT_VERSION:-26.2}"
SERVER_URL="${SERVER_URL:-https://piston-data.mojang.com/v1/objects/823e2250d24b3ddac457a60c92a6a941943fcd6a/server.jar}"
SERVER_SHA1="${SERVER_SHA1:-823e2250d24b3ddac457a60c92a6a941943fcd6a}"
MIN_RAM="${MIN_RAM:-1G}"
MAX_RAM="${MAX_RAM:-4G}"

cd /data

if [ ! -f server.jar ]; then
  echo "Downloading vanilla Minecraft ${MINECRAFT_VERSION} server..."
  curl -fL --retry 3 --output server.jar.tmp "$SERVER_URL"
  echo "${SERVER_SHA1}  server.jar.tmp" | sha1sum -c -
  mv server.jar.tmp server.jar
fi

echo "${SERVER_SHA1}  server.jar" | sha1sum -c -

if [ ! -f server.properties ]; then
  cp /defaults/server.properties server.properties
fi

if [ "${EULA:-FALSE}" = "TRUE" ]; then
  printf 'eula=true\n' > eula.txt
fi

if [ ! -f eula.txt ] || ! grep -q '^eula=true$' eula.txt; then
  echo "Minecraft EULA has not been accepted. Set EULA=TRUE after accepting https://aka.ms/MinecraftEULA"
  exit 1
fi

exec java \
  "-Xms${MIN_RAM}" \
  "-Xmx${MAX_RAM}" \
  -XX:+UseG1GC \
  -XX:+ParallelRefProcEnabled \
  -XX:MaxGCPauseMillis=200 \
  -XX:+DisableExplicitGC \
  -jar server.jar nogui
