#!/bin/bash

# verify maildir
if [ -d /var/mail/working ]; then
	echo "/var/mail/working exists"
else
	maildirmake /var/mail/working
	echo "to /var/mail/working" > /root/.mailfilter
fi

# check for user config fetchmailrc
if [ -f /config/.fetchmailrc ]; then
	cp /config/.fetchmailrc /root/.fetchmailrc
	chmod 0700 /root/.fetchmailrc
	echo "Installed .fetchmailrc"
fi

if [ "$1" = 'cron' ] || [ "$1" = '/opt/save-attachments.sh' ]; then
	if [ ! -f /root/.fetchmailrc ]; then
		echo "Cannot start container without .fetchmailrc"
		exit 1
	fi
fi

exec "$@"
