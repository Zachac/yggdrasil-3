#!/bin/bash

source "$( dirname "${BASH_SOURCE[0]}" )/../../PATHS" || exit $? 
SERVER_RUNTIME="$RUNTIME/server/$1"
CLIENT_OUT="$SERVER_RUNTIME/client_out"
LOCK="$SERVER_RUNTIME/lock"

if ! [ $# -eq 1 ] || ! [ "$1" -eq "$1" ]; then
	echo "Usage: client_handler.sh [port]"
	exit 1
fi	

mkdir -p "$SERVER_RUNTIME"


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

function hashPassword() {
	openssl dgst -sha256 -binary <<< "$@" | base64 -w0
}

function getPassword() {
	echo "Please enter a new password:"
	PASSWORD=$(hashPassword $USERNAME $(readLine))

	echo "Please enter the password again:"
	[ "$(hashPassword $USERNAME $(readLine))" = "$PASSWORD" ]
}

function validateUser() {
	echo "Please enter your password:"
        PASSWORD=$(hashPassword $USERNAME $(readLine))
	[ "$(cat "$USERS/$USERNAME/password")" = "$PASSWORD" ]
}

function login() {
	
	echo "Please enter your username:"
	USERNAME=$(readLine)

	until isValidUsername "$USERNAME"; do
		echo "Please enter a valid username"
		USERNAME=$(readLine)
	done


	if [ ! -f "$USERS/$USERNAME/password" ]; then
		echo "User $USERS/$USERNAME/password not found! Creating new user."

		until getPassword; do echo "Passwords do not match!"; done

		mkdir -p "$USERS/$USERNAME"

		echo "$PASSWORD" > "$USERS/$USERNAME/password"

		echo "New user created!"
	fi

	until validateUser; do echo "Invalid password"; done

	echo "Successfully logged in as $USERNAME"
}

function validArgs() {
	if [ $# -lt 1 ] || [ ${#1} -lt 1 ]; then
		return 1
	elif ! grep -q '^[a-zA-Z0-9]*$' <<< "$1"; then
		echo "Invalid charachters in command!"
		return 2
	elif ! [ -f $DIR/bin/"$1" ]; then
		echo "Command not found"
		return 3
	else
		return 0
	fi
}

function runPrompt() {	

	read -ra arguments <<< "$(readLine)"

	if validArgs "${arguments[@]}"; then
		source "$BIN/${arguments[0]}" "${arguments[@]:1}"
	fi

}

function initUser() {
	echo "Initializing..."
	source "$BIN/jump"	
}
 
function handleInput() {
	login
	initUser
	while true; do runPrompt; done
}


( flock -n 9 || exit -2; (
	mkfifo $CLIENT_OUT 2>/dev/null
	exec 3<>$CLIENT_OUT


	$DIR/net/server/ssl_socket.sh $1 1 >$CLIENT_OUT < <(handleInput)


); rm $SERVER_RUNTIME ) 9>$LOCK

echo "Server finished"

kill -- -$PGID

