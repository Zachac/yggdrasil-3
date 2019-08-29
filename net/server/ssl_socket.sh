#!/bin/bash

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )/../.." >/dev/null 2>&1 && pwd )"
source "$DIR/data/settings/server" || exit -1

SERVER_PORT=${1:-$SERVER_PORT}
KEY_FILE="$DIR/$SSL_KEY"
CERT_FILE="$DIR/$SSL_CERT"
PGID=$(ps -o pgid= $$ | grep -o [0-9]*)

if ! [ -z "$2" ] && [ "$2" -eq "$2" ]; then
	NACCEPT="-naccept $2"
fi


# Start server
echo "Starting server at $DIR on port $SERVER_PORT" >&2

function inputHandler() {
	
	# read the input from the socket
	# output only the properly encoded lines
	while read line; do
		# only accept lines starting with >
		if [ ${line:0:1} = '>' ]; then
			echo "${line:1}"
		elif [ "$line" = "CONNECTION CLOSED" ]; then
			echo "Client disconnected" >&2
		fi
	done

}

function outputHandler() {

	# read the desired output from stdin
	# output the encoded output to stdout	
	while read rawLine; do
		echo ">$rawLine"
	done

}

openssl s_server \
	-accept $SERVER_PORT \
	-key $KEY_FILE \
	-cert $CERT_FILE \
	-verify_quiet $NACCEPT \
	> >(inputHandler) \
	< <(outputHandler) 

echo "Server finished"

kill -- -$PGID


