# Java and Bedrock Crossplay Server

This branch runs a Paper 26.2 server with Geyser and Floodgate. Java players use the normal Paper port, while Bedrock players connect through Geyser's UDP port with their Bedrock/Xbox account. No Java account is required for Bedrock players.

## Ports

- Java Edition: TCP `25568`
- Bedrock Edition: UDP `19134`

Both host ports can be changed in `.env`. The non-default values avoid collisions with the other Minecraft servers on this host.

## Setup

```bash
./scripts/setup.sh
```

Review the [Minecraft EULA](https://aka.ms/MinecraftEULA). If accepted, set `EULA=TRUE` in `.env`, then start the server:

```bash
./scripts/start.sh
```

Paper, Geyser, and Floodgate are downloaded automatically. Persistent server files and worlds are stored in the ignored `data/` directory.

## Operations

```bash
docker compose logs -f crossplay
docker compose ps
./scripts/stop.sh
```

## Networking

Java Edition uses TCP, but Bedrock Edition uses UDP. A TCP-only ngrok tunnel can expose the Java port but cannot expose Bedrock. For public crossplay, forward both ports on the router or use a tunnel provider with UDP support such as playit.gg.

On a LAN, connect using the WSL/Windows host address:

- Java: `<host>:25568`
- Bedrock: `<host>` with port `19134`

## Compatibility

Geyser translates vanilla protocol and server-side plugin behavior. Java client mods and modded blocks/items cannot be translated to Bedrock, so this server intentionally stays Paper-based rather than sharing the Cobblemon installation.
