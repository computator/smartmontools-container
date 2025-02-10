#!/bin/sh

set -e

test -n "$REPORT_EMAIL" && \
	sed -Ei '/DEVICESCAN/ s/\-m root(@localhost)?( |$)/-m '"$REPORT_EMAIL"'\2/' /etc/smartd.conf

if [ -n "$SMARTHOST" ] && [ ! -f $HOME/.mailrc ]; then
	noscheme=$([ "${SMARTHOST#*://}" = "${SMARTHOST}" ] && echo 1) || :
	noauth=$([ "${SMARTHOST#*@}" = "${SMARTHOST}" ] && echo 1) || :
	cat <<-ENDCONFIG > $HOME/.mailrc
		set v15-compat
		${noauth:+set smtp-auth=none}
		set mta=${noscheme:+smtp://}${SMARTHOST}
	ENDCONFIG
fi

[ "$1" = "smartd" ] && shift
if [ $# -eq 0 ] || [ "${1#-}" != "${1}" ]; then
	set -- smartd -d "$@"
fi

exec "$@"
