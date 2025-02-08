#!/bin/sh

test -n "$REPORT_EMAIL" && \
	sed -Ei '/DEVICESCAN/ s/\-m root( |$)/-m '"$REPORT_EMAIL"'\1/' /etc/smartd.conf

[ "$1" = "smartd" ] && shift
if [ $# -eq 0 ] || [ "${1#-}" != "${1}" ]; then
	set -- smartd -d "$@"
fi

exec "$@"
