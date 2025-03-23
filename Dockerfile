FROM debian:jessie-slim

# Use archived repositories to avoid 404 errors
RUN sed -i 's/deb.debian.org/archive.debian.org/g' /etc/apt/sources.list && \
    sed -i 's|security.debian.org|archive.debian.org|g' /etc/apt/sources.list && \
    echo 'Acquire::Check-Valid-Until "false";' > /etc/apt/apt.conf.d/99no-check-valid-until && \
    apt-get update && apt-get install -y --no-install-recommends \
    wget unzip ca-certificates libcairo2 libc6 libfreetype6 libssl1.0.0 && \
    (cd /usr/local/bin && wget -O- http://get.pharo.org/64/vm130 | bash) && \
    mkdir -p /var/pharo/images/130 && \
    ln -sf /var/pharo/images/130 /var/pharo/images/default && \
    mkdir -p /var/pharo/images/130 && \
    cd /var/pharo/images/130 && wget -O- http://get.pharo.org/64/130 | bash && \
    apt-get purge -y --auto-remove wget unzip && \
    rm -rf /var/lib/apt/lists/*

ENTRYPOINT ["/usr/local/bin/pharo", "/var/pharo/images/default/Pharo.image"]
