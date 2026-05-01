FROM eclipse-temurin:8-jre

WORKDIR /opt/ccu-server

COPY docker/start.sh /start.sh

RUN apt-get update \
    && apt-get install -y --no-install-recommends ca-certificates curl unzip \
    && rm -rf /var/lib/apt/lists/* \
    && chmod +x /start.sh

ENTRYPOINT ["/start.sh"]
