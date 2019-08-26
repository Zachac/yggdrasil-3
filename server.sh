#!/bin/bash

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"
RUNTIME="$DIR/data/runtime"
STDOUT="$RUNTIME/stdout"
STDIN="$RUNTIME/stdin"

source "$DIR/data/settings/server"

echo "Starting server at $DIR on port $SERVER_PORT"

# Cleanup existing runtime directory
rm -r "$DIR/data/runtime" 2>/dev/null


# Setup files & data
mkdir "$DIR/data/runtime"

CLIENTS=()


# Start server
mkfifo $STDOUT
mkfifo $STDIN

openssl s_server -accept $SERVER_PORT -key data/certs/keyfile.key -cert data/certs/certfile.crt -naccept 1 -quiet -verify_quiet >$STDOUT <$STDIN &

while read line <$STDOUT; do
	echo "Line $line"
	echo "Line $line" >$STDIN
done




