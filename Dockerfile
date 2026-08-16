FROM eclipse-temurin:21-jre

WORKDIR /data

COPY docker/start.sh /usr/local/bin/start-cobblemon
RUN chmod +x /usr/local/bin/start-cobblemon

EXPOSE 25565
ENTRYPOINT ["/usr/local/bin/start-cobblemon"]
