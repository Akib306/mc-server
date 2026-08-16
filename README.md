# Optimized Cobblemon Server and Client

Fabric server and CurseForge client profile based on the official Cobblemon `1.7.3` pack for Minecraft `1.21.1`. Large mod, server, cache, world, and artifact files are downloaded or generated locally and are not committed.

## Optimization Stack

The official profile already includes Sodium, Lithium, FerriteCore, ImmediatelyFast, Entity Culling, Krypton, Clumps, and Let Me Despawn.

This project adds:

- Shared/server: ModernFix, ServerCore, NoisiumForked, Alternate Current
- Client: Dynamic FPS, MoreCulling, Enhanced Block Entities, BadOptimizations, Particle Core

Server-side-only optimization mods do not need to be present on clients, but they are included in the client profile so single-player worlds receive the same optimizations.

## Server

Requirements: Docker with Compose and `curl`. If `unzip` is unavailable, the fetcher uses a small Alpine container automatically.

```bash
./scripts/fetch-server.sh
cp .env.example .env
# Set EULA=TRUE only after accepting https://aka.ms/MinecraftEULA
docker compose up -d --build
```

The server listens on host port `25567`. Persistent data is stored in `server/`.

## Client

Building the import ZIP requires `zip` and `unzip`. A prebuilt artifact is also generated during deployment.

```bash
./scripts/build-client.sh
```

Import `artifacts/Cobblemon-Optimized-1.7.3-CurseForge.zip` into CurseForge with **Import Profile**. Allocate 6-8 GB of memory in the profile settings.

## Updating

All upstream files and added optimizers are pinned by CurseForge file ID and SHA-256 in `scripts/fetch-server.sh`. Update those pins together with `client/manifest.json` to keep the server and client compatible.
