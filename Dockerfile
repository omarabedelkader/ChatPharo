
FROM debian:bookworm-slim

RUN set -ex \
	&& buildDeps='wget unzip' \
	&& runtimeDeps='ca-certificates libcairo2 libc6 libfreetype6 libssl3' \
	&& apt-get update \
	&& apt-get install -y --no-install-recommends $buildDeps $runtimeDeps \
	&& (cd /usr/local/bin && wget -O- http://get.pharo.org/64/vmLatest | bash) \
	&& (mkdir -p /var/pharo/images/120; ln -sf /var/pharo/images/120 /var/pharo/images/default; cd /var/pharo/images/120 && wget -O- http://get.pharo.org/64/120 | bash) \
	&& apt-get purge -y --auto-remove $buildDeps \
	&& rm -rf /var/lib/apt/lists/* \
	&& true

ENTRYPOINT ["/usr/local/bin/pharo", "/var/pharo/images/default/Pharo.image"]
