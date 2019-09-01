#!/bin/bash

source "$( dirname "${BASH_SOURCE[0]}" )/../../PATHS" || exit $?
source "$SETTINGS/server" || exit $?

SERVER_PORT=${1:-$SERVER_PORT}

if [ ! "$SERVER_PORT" -gt 0 ]; then
	echo "Invalid arguments, expected server.sh [server_port]"
	exit 1
fi

$DIR/net/server/tcpsrv "localhost:$SERVER_PORT" "$DIR/net/server/client_handler.sh"

