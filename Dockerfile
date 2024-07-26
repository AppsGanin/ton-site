# Stage 1: Build
FROM ubuntu:24.04 AS sources

ENV DEBIAN_FRONTEND=noninteractive

WORKDIR /app

RUN apt update
RUN apt install --no-install-recommends -y  wget unzip apt-transport-https ca-certificates

RUN wget https://ton-blockchain.github.io/global.config.json
RUN wget https://github.com/ton-blockchain/ton/releases/download/v2024.06/ton-linux-x86_64.zip
RUN unzip ton-linux-x86_64.zip
RUN chmod +x generate-random-id rldp-http-proxy

RUN ls -la

# Stage 2: Run
FROM ubuntu:24.04

WORKDIR /app

RUN groupadd -g 1001 tonuser && useradd -u 1001 -g tonuser -d /app -s /sbin/nologin -c "TON User" tonuser

COPY --from=sources /app/generate-random-id /usr/local/bin
COPY --from=sources /app/rldp-http-proxy /usr/local/bin
COPY --from=sources /app/global.config.json /app

COPY entrypoint.sh entrypoint.sh

RUN chown -R 1001:1001 /app
RUN chmod +x /usr/local/bin/rldp-http-proxy
RUN chmod +x /usr/local/bin/generate-random-id
RUN chmod +x entrypoint.sh

ENV SERVER_IP 127.0.0.1
ENV ADNL_PORT 3333
ENV REMOTE_IP 8.8.8.8
ENV REMOTE_PORT 443
ENV CONFIG_PATH "/app/global.config.json"

ENTRYPOINT ["./entrypoint.sh"]
