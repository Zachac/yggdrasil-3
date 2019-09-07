#!/bin/bash

source "$( dirname "${BASH_SOURCE[0]}" )/../../env" || exit $?

SERVER_PORT=${2:-$SERVER_PORT}
SERVER_HOST=${1:-$SERVER_HOST}


# Client is just netcat with a custom quit command

function readInput() {

	while read -r value; do
		echo "$value"
		
		if [ "${value,,}" = "q" ] || [ "${value,,}" = "quit" ]; then
			echo "Closing connection" >&2
			break
		fi
	done
}

nc "$SERVER_HOST" "$SERVER_PORT" < <(readInput)

