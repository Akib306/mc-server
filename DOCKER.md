# Docker Setup

This server can run in Docker with Java 8. You can either keep the extracted server files in this folder, or let Docker bootstrap them from a zip so you do not have to commit the whole modpack.

## Requirements

- Docker Desktop
- At least 10 GB of RAM available to Docker if you keep the default `8G` server allocation

## Option 1: Bootstrap from a local zip

Put the Crazy Craft server pack zip at `bootstrap/modpack.zip`, then run:

```bash
docker compose up -d --build
```

On first start, the container will unzip the pack into this folder and then launch Forge.

## Option 2: Bootstrap from a download URL

Set `MODPACK_URL` in [`docker-compose.yml`](/Users/kararal-shanoon/Desktop/mc-server/docker-compose.yml) to a direct zip download, then run:

```bash
docker compose up -d --build
```

The container will download the archive, unzip it into this folder, and start the server.

## Start the server

From this folder, run:

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

For example, for 6 GB:

```yaml
MIN_RAM: 6G
MAX_RAM: 6G
```

## Notes

- `bootstrap/*.zip` is ignored by git, so you can keep the server pack archive locally without committing it.
- The extracted server files are still written into this folder because it is mounted as `/data`.
- `eula.txt` is already set to `true`, so there is no extra EULA step.
- If you want to connect from the same machine, use `localhost:25565`.
- If friends are joining over the internet, you will still need to port-forward `25565/TCP` on your router.
