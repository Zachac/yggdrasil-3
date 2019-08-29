#!/bin/bash

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )/../.." >/dev/null 2>&1 && pwd )" || exit -1
RUNTIME="$DIR/data/runtime/server/$1"
CLIENT_OUT="$RUNTIME/client_out"
LOCK="$RUNTIME/lock"

if ! [ $# -eq 1 ] || ! [ "$1" -eq "$1" ]; then
	echo "Usage: client_handler.sh [port]"
	exit 1
fi	

mkdir -p "$RUNTIME"


function readLine() {
	read line <$CLIENT_OUT && echo "$line"
}

function isValidUsername() {

	if ! grep -q '^[a-zA-Z0-9]*$' <<< "$@"; then
		echo "Username contains invalid charachters"
		return 1
	elif [ ${#1} -lt 1 ] || [ ${#1} -gt 16 ]; then
		echo "Username must be between 1-16 charachters in length"
		return 2
	else
		return 0
	fi

}

function handleInput() {
	
	echo "Please enter a username:"
	USERNAME=$(readLine)

	until isValidUsername "$USERNAME"; do
		echo "Please enter a valid username"
		USERNAME=$(readLine)
	done

	if [ ! -f "$DIR/data/users/$USERNAME/password" ]; then
		echo "User not found! Creating new user."
	fi

	echo "Your username is $USERNAME"
}


( flock -n 9 || exit -2; (
	mkfifo $CLIENT_OUT 2>/dev/null
	exec 3<>$CLIENT_OUT


	$DIR/net/server/ssl_socket.sh $1 >$CLIENT_OUT < <(handleInput)


); rm $RUNTIME ) 9>$LOCK


