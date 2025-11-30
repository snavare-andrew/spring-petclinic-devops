FROM zaproxy/zap-stable

USER root

RUN apt-get update && \
    apt-get install -y chromium chromium-driver && \
    apt-get clean && rm -rf /var/lib/apt/lists/*

USER zap

