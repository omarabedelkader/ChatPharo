FROM debian:bookworm-slim

# Install dependencies for both Pharo and Ollama
RUN set -ex \
  && buildDeps='wget unzip curl gnupg lsb-release' \
  && runtimeDeps='ca-certificates libcairo2 libc6 libfreetype6 libssl3' \
  && apt-get update \
  && apt-get install -y --no-install-recommends $buildDeps $runtimeDeps \
  \
  # Install Pharo VM and image
  && (cd /usr/local/bin && wget -O- http://get.pharo.org/64/vmLatest | bash || echo "VM download failed") \
  && (mkdir -p /var/pharo/images/120; ln -sf /var/pharo/images/120 /var/pharo/images/default; cd /var/pharo/images/120 && wget -O- http://get.pharo.org/64/120 | bash) \
  \
  # Install Ollama
  && curl -fsSL https://ollama.com/install.sh | sh \
  && ollama pull llama3 \
  \
  # Clean up
  && apt-get purge -y --auto-remove $buildDeps \
  && rm -rf /var/lib/apt/lists/* \
  && true

# Expose Ollama's default API port
EXPOSE 11434

# Start both Ollama and Pharo when the container runs
CMD ollama serve & /usr/local/bin/pharo /var/pharo/images/default/Pharo.image
