#!/bin/sh
set -eu

MIN_RAM="${MIN_RAM:-2G}"
MAX_RAM="${MAX_RAM:-8G}"

FABRIC_JAR="$(find /data -maxdepth 1 -type f -name 'fabric-server-*.jar' | head -n 1)"
if [ -z "$FABRIC_JAR" ]; then
  echo "Fabric server launcher not found. Run ./scripts/fetch-server.sh first."
  exit 1
fi

if [ "${EULA:-FALSE}" = "TRUE" ]; then
  printf 'eula=true\n' > /data/eula.txt
fi

if [ ! -f /data/eula.txt ] || ! grep -q '^eula=true$' /data/eula.txt; then
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
  -XX:+PerfDisableSharedMem \
  -jar "$FABRIC_JAR" nogui
