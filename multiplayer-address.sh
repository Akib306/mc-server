#!/bin/sh

set -eu

if command -v curl >/dev/null 2>&1; then
  address="$(
    curl -fsS http://127.0.0.1:4040/api/tunnels 2>/dev/null | python3 -c '
import json
import sys

data = json.load(sys.stdin)
for tunnel in data.get("tunnels", []):
    public_url = tunnel.get("public_url", "")
    if public_url.startswith("tcp://"):
        print(public_url[len("tcp://"):])
        break
' 2>/dev/null || true
  )"

  if [ -n "${address}" ]; then
    printf '%s\n' "${address}"
    exit 0
  fi
fi

docker logs mc-ngrok 2>&1 | sed -n 's/.*url=tcp:\\/\\///p' | tail -n 1
