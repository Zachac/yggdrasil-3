#!/bin/bash

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )/../.." >/dev/null 2>&1 && pwd )"
source "$DIR/data/settings/server" || exit -1
SERVER_PORT=${1:-$SERVER_PORT}
RUNTIME="$DIR/data/runtime/server/$SERVER_PORT"
RAW_STDOUT="$RUNTIME/raw_stdout"
RAW_STDIN="$RUNTIME/raw_stdin"
STDIN="$RUNTIME/stdin"


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
mkfifo $RAW_STDIN
mkfifo $RAW_STDOUT

exec 3<>$RAW_STDIN
exec 4<>$RAW_STDOUT


# Define a cleanup function
function cleanup() {
	rm -r $RUNTIME
	kill -- -$PGID
}

( # Start server
	echo "Starting server at $DIR on port $SERVER_PORT"
	cat <&3 | openssl s_server -accept $SERVER_PORT -key $KEY_FILE -cert $CERT_FILE -verify_quiet $NACCEPT >&4
	echo "Server finished"
	cleanup
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

cleanup
