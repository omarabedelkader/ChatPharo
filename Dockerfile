FROM debian:bookworm-slim

# Install common dependencies
RUN apt-get update && apt-get install -y \
    curl wget unzip gnupg lsb-release ca-certificates \
    libcairo2 libc6 libfreetype6 libssl3 \
    fuse \
 && rm -rf /var/lib/apt/lists/*

# Install Pharo
RUN cd /usr/local/bin && wget -O- http://get.pharo.org/64/vmLatest | bash || echo "VM download failed"
RUN mkdir -p /var/pharo/images/120 && ln -sf /var/pharo/images/120 /var/pharo/images/default \
 && cd /var/pharo/images/120 && wget -O- http://get.pharo.org/64/120 | bash

# Install Ollama
RUN curl -fsSL https://ollama.com/install.sh | sh

# Pull a model (this might fail during build if Ollama requires a running service)
# You can also move this to runtime if it fails here
RUN /root/.ollama/bin/ollama run codellama:7b || echo "Skipping model pull during build"

# Expose Ollama port
EXPOSE 11434

# Start both services
CMD /root/.ollama/bin/ollama serve & /usr/local/bin/pharo /var/pharo/images/default/Pharo.image
