FROM docker.io/library/alpine

LABEL org.opencontainers.image.source=https://github.com/computator/smartmontools-container

RUN set -eux; \
	apk add --no-cache smartmontools s-nail; \
	echo 'DEVICESCAN -a -n standby -m root@localhost -M diminishing' > /etc/smartd.conf

COPY entrypoint.sh /

ENV SMARTHOST=localhost
VOLUME /var/lib/smartmontools
ENTRYPOINT ["/entrypoint.sh"]
CMD ["smartd", \
	"--attributelog=/var/lib/smartmontools/attrlog.", \
	"--savestates=/var/lib/smartmontools/smartd." \
]
