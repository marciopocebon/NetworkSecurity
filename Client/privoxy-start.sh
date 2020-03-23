#!/bin/sh

CONFFILE=/etc/privoxy/config
PIDFILE=/var/run/privoxy.pid


if [ ! -f "${CONFFILE}" ]; then
	echo "Configuration file ${CONFFILE} not found!"
	exit 1
fi

cd /usr/local/etc/privoxy
cp -R * /etc/privoxy/
/usr/local/sbin/privoxy --no-daemon --pidfile "${PIDFILE}" "${CONFFILE}"

