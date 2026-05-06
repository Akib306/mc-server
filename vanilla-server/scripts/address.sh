#!/usr/bin/env bash
set -euo pipefail

container="${1:-mc-ngrok}"

address="$(
  docker logs "$container" 2>&1 \
    | grep -Eo 'url=tcp://[a-zA-Z0-9.-]+:[0-9]+' \
    | sed 's|url=tcp://||' \
    | tail -n 1 || true
)"

if [[ -z "$address" ]]; then
  echo "No ngrok TCP address found in logs for container: $container" >&2
  echo "Start the stack first, then try again." >&2
  exit 1
fi

echo "$address"
