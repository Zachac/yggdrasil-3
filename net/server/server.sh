#!/bin/bash

source "$( dirname "${BASH_SOURCE[0]}" )/../../PATHS" || exit $?
source "$SETTINGS/server" || exit $?

SERVER_PORT=${1:-$SERVER_PORT}

if [ ! "$SERVER_PORT" -gt 0 ]; then
	echo "Invalid arguments, expected server.sh [server_port]"
	exit 1
fi


( # Trigger background process while server listens to ports

	LAST_TICK=$(($(date +%s) + 1))
	
	while sleep 1; do
		TICK=$(date +%s)
		
		for t in $(seq $LAST_TICK $TICK); do
			if [ "${TICK: -1}" = 0 ]; then
				$DIR/net/server/sweep.sh
			fi
		done

		LAST_TICK=$((TICK + 1))
	done

) &


$DIR/net/server/tcpsrv "localhost:$SERVER_PORT" "$DIR/net/server/client_handler.sh"

