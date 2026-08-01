FROM eclipse-temurin:25-jre

RUN apt-get update \
    && apt-get install -y --no-install-recommends ca-certificates curl \
    && rm -rf /var/lib/apt/lists/*

WORKDIR /data

COPY docker/start.sh /usr/local/bin/start-minecraft
COPY server.properties /defaults/server.properties

RUN chmod +x /usr/local/bin/start-minecraft

EXPOSE 25565
ENTRYPOINT ["/usr/local/bin/start-minecraft"]
