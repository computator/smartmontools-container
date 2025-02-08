FROM docker.io/library/alpine

LABEL org.opencontainers.image.source=https://github.com/computator/smartmontools-container

RUN set -ex; \
	apk add --no-cache smartmontools; \
	echo 'DEVICESCAN -a -n standby -m root -M diminishing' > /etc/smartd.conf

COPY entrypoint.sh /

ENTRYPOINT ["/entrypoint.sh"]
CMD ["smartd"]
VOLUME /var/lib/smartmontools
