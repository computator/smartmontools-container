#!/bin/sh

set -e

test -n "$REPORT_EMAIL" && \
	sed -Ei '/DEVICESCAN/ s/\-m root(@localhost)?( |$)/-m '"$REPORT_EMAIL"'\2/' /etc/smartd.conf

if [ -n "${MAILNAME}${SMARTHOST}" ] && [ ! -f $HOME/.mailrc ]; then
	if [ -n "${SMARTHOST}" ]; then
		noscheme=$([ "${SMARTHOST#*://}" = "${SMARTHOST}" ] && echo 1) || :
		noauth=$([ "${SMARTHOST#*@}" = "${SMARTHOST}" ] && echo 1) || :
	fi

	{
		echo "set v15-compat"
		[ -n "$MAILNAME" ] &&
			echo "set hostname=${MAILNAME}"
		[ -n "$SMARTHOST" ] &&
			cat <<-ENDCONFIG
				${noauth:+set smtp-auth=none}
				set mta=${noscheme:+smtp://}${SMARTHOST}
			ENDCONFIG
	} > $HOME/.mailrc
fi

[ "$1" = "smartd" ] && shift
if [ $# -eq 0 ] || [ "${1#-}" != "${1}" ]; then
	set -- smartd -d "$@"
fi

exec "$@"
