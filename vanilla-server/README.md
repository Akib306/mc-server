# Minecraft Server

Docker Compose setup for an unmodded Minecraft server with ngrok TCP forwarding.

The default server type is Paper. This keeps the gameplay client-compatible and unmodded, but uses a faster and more configurable server implementation than Mojang's vanilla server jar.

## Files

- `docker-compose.yml` starts a Paper Minecraft server by default using `itzg/minecraft-server`.
- `docker-compose.forge.yml` switches the Minecraft container to Forge and mounts `./mods` read-only.
- `.env.example` documents the required and optional settings.
- `scripts/start.sh` starts the default Paper server.
- `scripts/start-forge.sh` starts the Forge variant.
- `scripts/address.sh` prints the current ngrok TCP address from container logs.

## Quick Start

1. Copy the example environment file:

   ```bash
   cp .env.example .env
   ```

2. Edit `.env` and set `NGROK_AUTHTOKEN` to your ngrok auth token.

3. Start the unmodded Paper server:

   ```bash
   ./scripts/start.sh
   ```

4. Wait for the Minecraft logs to show that the server is done starting.

5. In another terminal, print the public ngrok server address:

   ```bash
   ./scripts/address.sh
   ```

6. Copy the printed `host:port` value into Minecraft as the server address.

Minecraft listens locally on `localhost:25565` by default, or on `localhost:$MC_PORT` if you change `MC_PORT` in `.env`. Inside Docker and ngrok, the server still listens on `minecraft:25565`; changing `MC_PORT` only changes the host machine port.

The world and server files are stored in the `mc_data` Docker volume.

## Modded Forge Server

The Forge setup is optional and only needed when you want to run mods.

1. Put mod `.jar` files in `./mods`.

2. Start the Forge variant:

   ```bash
   ./scripts/start-forge.sh
   ```

The folder is mounted read-only into the container so the container cannot accidentally modify your local mod files.

## Commands

Start Paper:

```bash
docker compose up -d
```

Start Forge:

```bash
docker compose -f docker-compose.yml -f docker-compose.forge.yml up -d
```

Show logs:

```bash
docker compose logs -f minecraft ngrok
```

Print the public ngrok Minecraft address:

```bash
./scripts/address.sh
```

Equivalent one-liner:

```bash
docker logs mc-ngrok 2>&1 | grep -Eo 'url=tcp://[a-zA-Z0-9.-]+:[0-9]+' | sed 's|url=tcp://||' | tail -n 1
```
