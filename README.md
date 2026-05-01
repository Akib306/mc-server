# Crazy Craft Docker Wrapper

This repo keeps only the Docker files and startup wrapper. Download the actual Crazy Craft server files elsewhere, then place them in this folder before starting the container.

## Required server files

At minimum, this folder should contain:

- `forge.jar`
- `mods/`
- `config/`
- `defaultconfigs/`
- `libraries/`
- `server.properties`
- `eula.txt`

## Start the server

1. Download or extract the Crazy Craft server pack into this folder.
2. Start the container:

```bash
docker compose up -d --build
```

The server will be available on port `25565`.

To watch logs:

```bash
docker compose logs -f
```

To stop it:

```bash
docker compose down
```

## Change RAM

Edit [`docker-compose.yml`](/Users/kararal-shanoon/Desktop/mc-server/docker-compose.yml) and change:

```yaml
MIN_RAM: 8G
MAX_RAM: 8G
```

## Notes

- The repo root is mounted directly into `/data` in the container.
- If `forge.jar` is missing, the container exits with a clear error.
- If you want to connect from the same machine, use `localhost:25565`.
