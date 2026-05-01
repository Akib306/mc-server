#!/bin/sh
set -eu

SERVER_DIR="${SERVER_DIR:-/data}"
MIN_RAM="${MIN_RAM:-8G}"
MAX_RAM="${MAX_RAM:-8G}"
JAVA_OPTS="${JAVA_OPTS:-}"

cd "$SERVER_DIR"

if [ ! -f forge.jar ]; then
  echo "forge.jar was not found in $SERVER_DIR"
  echo "Mount the server pack directory to /data before starting the container."
  exit 1
fi

exec java $JAVA_OPTS "-Xms${MIN_RAM}" "-Xmx${MAX_RAM}" -jar forge.jar nogui
