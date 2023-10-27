#!/bin/ash
# shellcheck shell=dash
set -e

# first arg is `--some-option`
if [ "$(echo "$1" | \
	awk  '{ string=substr($0, 1, 1); print string; }' )" = '-' ]; then
	set -- rexray start --nopid "$@"
fi

#set default rexray options
REXRAY_FSTYPE="${REXRAY_FSTYPE:-ext4}"
REXRAY_LOGLEVEL="${REXRAY_LOGLEVEL:-warn}"
REXRAY_PREEMPT="${REXRAY_PREEMPT:-false}"

if [ "$1" = 'rexray' ]; then

	for rexray_option in \
		fsType \
		loglevel \
		preempt \
	; do
		val=$(eval echo "\$REXRAY_$(echo $rexray_option | \
			awk '{print toupper($0)}')")
		if [ "$val" ]; then
			sed -ri 's/^([\ ]*'"$rexray_option"':).*/\1 '"$val"'/' \
				/etc/rexray/rexray.yml
		fi
	done

fi

exec "$@"
