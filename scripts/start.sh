#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"

cd "$ROOT_DIR"

if [[ ! -f .env ]]; then
  ./scripts/setup.sh
fi

set -a
# shellcheck disable=SC1091
source .env
set +a

if [[ "${EULA:-FALSE}" != "TRUE" ]]; then
  echo "EULA is not accepted. Set EULA=TRUE in .env after accepting https://aka.ms/MinecraftEULA"
  exit 1
fi

docker compose up -d
docker compose ps

echo "Java:   <host>:${JAVA_PORT:-25568} (TCP)"
echo "Bedrock: <host>:${BEDROCK_PORT:-19134} (UDP)"
