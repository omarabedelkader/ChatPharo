ARG OLLAMA_VERSION=latest
FROM ollama/ollama:${OLLAMA_VERSION} AS base

# 2. Install dependencies + Pharo
RUN apt-get update && apt-get install -y \
    curl wget unzip gnupg lsb-release ca-certificates \
    libcairo2 libc6 libfreetype6 libssl3 fuse \
 && rm -rf /var/lib/apt/lists/*

# 3. Install Pharo
RUN curl -L https://get.pharo.org/64 | bash \
 && mv pharo /usr/local/bin/pharo \
 && mv pharo-vm /usr/local/bin/pharo-vm \
 && mkdir -p /var/pharo/images/default \
 && mv Pharo.image /var/pharo/images/default/Pharo.image \
 && mv Pharo.changes /var/pharo/images/default/Pharo.changes

# 4. Workdir and expose
WORKDIR /var/pharo/images/default
EXPOSE 11434

CMD /root/.ollama/bin/ollama serve & \
    /usr/local/bin/pharo Pharo.image
