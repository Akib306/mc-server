#!/usr/bin/env bash
set -euo pipefail

cd "$(dirname "$0")/.."

if [[ ! -f .env ]]; then
  cp .env.example .env
  echo "Created .env from .env.example."
  echo "Edit .env and set NGROK_AUTHTOKEN before starting the server."
  exit 1
fi

docker compose up -d
docker compose logs -f minecraft ngrok
