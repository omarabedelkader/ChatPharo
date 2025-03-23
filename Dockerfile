#
# NOTE: THIS DOCKERFILE IS GENERATED VIA "update.sh"
#
# PLEASE DO NOT EDIT IT DIRECTLY.
#
FROM debian:jessie-slim

RUN set -ex \
	&& buildDeps='wget unzip' \
	&& runtimeDeps='ca-certificates libcairo2 libc6 libfreetype6 libssl1.0.0' \
	&& apt-get update \
	&& apt-get install -y --no-install-recommends $buildDeps $runtimeDeps \
	&& (cd /usr/local/bin && wget -O- http://get.pharo.org/64/vm70 | bash ) \
        && (mkdir -p /var/pharo/images/70; ln -sf /var/pharo/images/70 /var/pharo/images/default; cd /var/pharo/images/70 && wget -O- http://get.pharo.org/64/70 | bash) \
	&& apt-get purge -y --auto-remove $buildDeps \
	&& rm -rf /var/lib/apt/lists/* \
	&& true 

ENTRYPOINT ["/usr/local/bin/pharo", "/var/pharo/images/default/Pharo.image"]
