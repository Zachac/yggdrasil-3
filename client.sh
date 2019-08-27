#!/bin/bash

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"
RUNTIME="$DIR/data/runtime/client"
STDOUT="$RUNTIME/stdout"
STDIN="$RUNTIME/stdin"

source "$DIR/data/settings/client"

PID=$$

# Cleanup existing runtime directory
rm -r "$RUNTIME" 2>/dev/null
mkdir -p "$RUNTIME"

# Init file descriptors
mkfifo $STDIN
mkfifo $STDOUT

exec 3<>$STDIN
exec 4<>$STDOUT

# Start client
(
	cat <&3 | openssl s_client -connect "$SERVER_HOST:$SERVER_PORT" -quiet -verify_quiet
	echo "Disconnected"
	kill $PID
) &

# Preprocess input before feeding to server
while read line; do
	echo ">$line" >&3
done

