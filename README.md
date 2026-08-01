# Vanilla Hardcore Server

Dockerized vanilla Minecraft `26.2` hardcore server. The official server JAR is downloaded from Mojang at runtime and verified against its pinned SHA-1, so no large binaries or world files are committed.

## Requirements

- Docker with Compose
- Acceptance of the [Minecraft EULA](https://aka.ms/MinecraftEULA)

## Start

```bash
cp .env.example .env
# Change EULA=FALSE to EULA=TRUE only after accepting the Minecraft EULA.
docker compose up -d --build
```

The server listens on host port `25566`, keeping port `25565` available for Crazy Craft.

## Operations

```bash
docker compose logs -f --tail=200
docker compose down
```

Persistent server files and the hardcore world live under `data/` and are ignored by Git.

## Pinned Runtime

- Minecraft: `26.2`
- Java: `25`
- Server SHA-1: `823e2250d24b3ddac457a60c92a6a941943fcd6a`
- Heap: `1G` minimum, `4G` maximum
