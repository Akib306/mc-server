# Minecraft Server (Docker + ngrok)

Simple Docker setup for a Minecraft Paper server, exposed to friends over ngrok TCP.

## Prerequisites

- Docker Desktop (or Docker Engine + Compose)
- An ngrok account and authtoken

## Setup

1. Create a `.env` file in this folder:

   ```env
   NGROK_AUTHTOKEN=your_ngrok_authtoken_here
   ```

2. (Optional) Make the helper script executable:

   ```bash
   chmod +x multiplayer-address.sh
   ```

## Start the server

```bash
./start-server.sh
```

This starts:

- `minecraft-forge` (Forge Minecraft server)
- `mc-ngrok` (TCP tunnel to the server)

## Get the multiplayer address

If you want to fetch the tunnel again later, run:

```bash
./multiplayer-address.sh
```

It prints the ngrok host and port (for example: `0.tcp.ngrok.io:12345`).

Share that address with players and use it in Minecraft **Multiplayer → Add Server**.

## Stop the server

```bash
docker compose down
```

## Data and persistence

- World and server data are stored in `./data`.
- Your world persists between restarts.

## Useful commands

- View server logs:

  ```bash
  docker logs -f mc-server
  ```

- View ngrok logs:

  ```bash
  docker logs -f mc-ngrok
  ```

- Restart services:

  ```bash
  docker compose restart
  ```

