#!/bin/sh

set -eu

docker compose up -d "$@"

printf 'Waiting for ngrok tunnel...\n' >&2

attempt=1
max_attempts=30

while [ "${attempt}" -le "${max_attempts}" ]; do
  address="$(./multiplayer-address.sh 2>/dev/null || true)"

  if [ -n "${address}" ]; then
    printf 'Minecraft multiplayer address: %s\n' "${address}"
    exit 0
  fi

  sleep 2
  attempt=$((attempt + 1))
done

printf 'The server started, but ngrok did not publish an address yet.\n' >&2
printf 'Run ./multiplayer-address.sh in a few seconds to fetch it.\n' >&2
