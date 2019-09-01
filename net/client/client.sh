#!/bin/bash

source "$( dirname "${BASH_SOURCE[0]}" )/../../PATHS" || exit $?
source "$SETTINGS/client" || exit $?
SERVER_PORT=${2:-$SERVER_PORT}
SERVER_HOST=${1:-$SERVER_HOST}
SERVER="$SERVER_HOST:$SERVER_PORT"


function filterOutput() {
	# Filter output and send to stdout
	while read line; do
		if [ "${line:0:1}" = ">" ]; then
			echo "${line:1}"
		elif ! [ "${line:0:1}" = "#" ]; then
			echo "unkown input: $line"
		fi
	done
}

function waitForConnectionClose() {

	# Wait for error signal from client indicating server has finished
	while read line; do
		if grep -q '^[a-zA-Z][a-zA-Z]*:errno=[0-9][0-9]*$' <<<$line; then
			echo "Disconnected"
			kill -- -$PGID
		fi
	done

}

function readInput() {
	while read line; do
		echo ">$line"
	done
}

echo "Starting client to $SERVER"

openssl s_client -connect "$SERVER" -quiet -verify_quiet \
	< <(readInput) \
	> >(filterOutput) \
	2> >(waitForConnectionClose)

echo "Disconnected"

kill -- -$PGID

