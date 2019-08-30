#!/bin/bash

source "$( dirname "${BASH_SOURCE[0]}" )/../../PATHS" || exit $?
source "$SETTINGS/client" || exit $?
SERVER_PORT=${2:-$SERVER_PORT}
SERVER_HOST=${1:-$SERVER_HOST}
SERVER="$SERVER_HOST:$SERVER_PORT"
CLIENT_RUNTIME="$DIR/data/runtime/client"
STDOUT="$CLIENT_RUNTIME/stdout"
STDIN="$CLIENT_RUNTIME/stdin"
STDERR="$CLIENT_RUNTIME/err"


# Cleanup existing runtime directory
rm -r "$CLIENT_RUNTIME" 2>/dev/null
mkdir -p "$CLIENT_RUNTIME"

# Init file descriptors
mkfifo $STDIN
mkfifo $STDOUT
mkfifo $STDERR

exec 3<>$STDIN
exec 4<>$STDOUT
exec 5<>$STDERR


( # Start client
	echo "Starting client to $SERVER"
	cat <&3 | openssl s_client -connect "$SERVER" -quiet -verify_quiet >&4 2>&5
	echo "Disconnected"
	kill -- -$PGID
) &


( # Filter output and send to stdout
	while read line <&4; do
		if [ "${line:0:1}" = ">" ]; then
			echo "${line:1}"
		elif ! [ "${line:0:1}" = "#" ]; then
			echo "unkown input: $line"
		fi
	done
) &

( # Wait for error signal from client indicating server has finished
	while read line <&5; do
		if grep -q '^[a-zA-Z][a-zA-Z]*:errno=[0-9][0-9]*$' <<<$line; then
			echo "Disconnected"
			kill -- -$PGID
		fi
	done
) &

# Preprocess input and then feed to server
while read line; do
	echo ">$line" >&3
done

