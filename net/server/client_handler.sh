#!/bin/bash

source "$( dirname "${BASH_SOURCE[0]}" )/../../PATHS" || exit
SERVER_RUNTIME="$RUNTIME/server"
CONNECTED_PLAYERS="$SERVER_RUNTIME/players"

# create runtime folders
mkdir -p "$CONNECTED_PLAYERS" || exit

# define functions

function readLine() {
	read line || exit 1
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
	openssl dgst -sha256 -binary <<< "$*" | base64 -w0
}

function getPassword() {
	echo "Please enter a new password:"
	readLine
	PASSWORD=$(hashPassword $USERNAME $line)

	echo "Please enter the password again:"
	readLine
	[ "$(hashPassword $USERNAME $line)" = "$PASSWORD" ]
}

function validateUser() {
	echo "Please enter your password:"
	readLine
        PASSWORD=$(hashPassword $USERNAME $line)
	[ "$(cat "$USERS/$USERNAME/password")" = "$PASSWORD" ]
}


function getUsername() {
	
	echo "Please enter your username:"
	readLine
	USERNAME=$line

	until isValidUsername "$USERNAME"; do
		echo "Please enter a valid username"
		readLine
		USERNAME=$line
	done

	if [ ! -d "$USERS/$USERNAME" ]; then
		mkdir -p "$USERS/$USERNAME"
	fi

	exec 8<> "$USERS/$USERNAME/lock"

	if ! flock -n 8 ; then
		8<&-
		echo "User is already logged in"
		return 1
	fi
}

function login() {
	
	until getUsername; do :; done
	

	if [ ! -f "$USERS/$USERNAME/password" ]; then
		echo "Could not find a password for $USERNAME, let's create a new one."

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
	elif grep -q '[.*]' <<< "$*"; then
		echo "Invalid charachters in commands!"
		return 3
	else
		return 0
	fi
}

function runPrompt() {	
	
	readLine
	read -ra arguments <<< "$line"

	if validArgs "${arguments[@]}"; then
		if [ -f "$BIN/${arguments[0]}" ]; then
			source "$BIN/${arguments[0]}" "${arguments[@]:1}"
		elif [ -L "$OBVIOUS_EXITS/${arguments[*]}" ]; then
			source "$BIN/jump" "$($BIN/location "$(realpath "$OBVIOUS_EXITS/${arguments[*]}")")"
		else
			echo "Command not found"
		fi
		
	fi

}

function initUser() {
	echo "Initializing..."
	echo "$BASHPID" > "$USERS/$USERNAME/proc"
	
	if [ ! -e "$CONNECTED_PLAYERS/$USERNAME" ]; then
		ln -s "$USERS/$USERNAME" "$CONNECTED_PLAYERS/$USERNAME"
	fi

	source "$BIN/jumpf"
}
 
function handleInput() {
	login
	initUser
	while true; do runPrompt; done
}

handleInput 31> >(cat)

kill -- -$PGID

