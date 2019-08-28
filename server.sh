#!/bin/bash

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"
source "$DIR/data/settings/server"
SERVER_PORT=${1:-$SERVER_PORT}
RUNTIME="$DIR/data/runtime/server/$SERVER_PORT"
STDOUT="$RUNTIME/stdout"
STDIN="$RUNTIME/stdin"
FILTER="$RUNTIME/filter"

KEY_FILE="$DIR/$SSL_KEY"
CERT_FILE="$DIR/$SSL_CERT"
PID=$$
PGID=$(ps -o pgid= $PID | grep -o [0-9]*)

if ! [ -z "$2" ] && [ "$2" -eq "$2" ]; then
	NACCEPT="-naccept $2"
fi

# Cleanup existing runtime directory
rm -r "$RUNTIME" 2>/dev/null
mkdir -p "$RUNTIME"

# Init file descriptors
mkfifo $STDIN
mkfifo $STDOUT
mkfifo $FILTER

exec 3<>$STDIN
exec 4<>$STDOUT
exec 5<>$FILTER


( # Start server
	echo "Starting server at $DIR on port $SERVER_PORT"
	cat <&3 | openssl s_server -accept $SERVER_PORT -key $KEY_FILE -cert $CERT_FILE -verify_quiet $NACCEPT >&4
	echo "Server finished"
	kill -- -$PGID
) &

( # Handle input
	while read line <&4; do
		# only accept lines starting with >
		if [ ${line:0:1} = '>' ]; then
			echo "${line:1}"
		elif [ "$line" = "CONNECTION CLOSED" ]; then
			echo "#" >&3
			echo "Client disconnected"
		fi
	done
) &

# Encode output
while read rawLine; do
	echo ">$rawLine" >&3
done


kill -- -$PGID

