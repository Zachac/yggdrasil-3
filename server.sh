#!/bin/bash

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"
RUNTIME="$DIR/data/runtime/server"
STDOUT="$RUNTIME/stdout"
STDIN="$RUNTIME/stdin"
FILTER="$RUNTIME/filter"

source "$DIR/data/settings/server"

KEY_FILE="$DIR/$SSL_KEY"
CERT_FILE="$DIR/$SSL_CERT"
CLIENTS=()
PID=$$

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
	cat <&3 | openssl s_server -accept $SERVER_PORT -key $KEY_FILE -cert $CERT_FILE -naccept 1 -verify_quiet >&4
	echo "Server finished"
) &

( # Encode output
	while read rawLine <&5; do
		echo ">$rawLine" >&3
	done
) &

# Handle input
while read line <&4; do
	# only accept lines starting with >
	if [ ${line:0:1} = '>' ]; then
		echo "Accepting ${line:1}"
		echo "${line:1}" >&5
	elif [ "$line" = "CONNECTION CLOSED" ]; then
		break
	fi
done

