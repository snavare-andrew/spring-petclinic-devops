FROM zaproxy/zap-stable

RUN apt-get update && \
    apt-get install -y chromium chromium-driver && \
    apt-get clean && rm -rf /var/lib/apt/lists/*

USER zap

