FROM eclipse-temurin:8-jre

WORKDIR /opt/ccu-server

COPY docker/start.sh /start.sh

RUN chmod +x /start.sh

ENTRYPOINT ["/start.sh"]
