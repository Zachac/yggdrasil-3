#!/bin/bash

source "$( dirname "${BASH_SOURCE[0]}" )/../../env" || exit

# create runtime folders if not already existing
mkdir -p "$CONNECTED_PLAYERS" || exit


function getUsername() {
	
	prompt "Please enter your username:"
	until isValidUsername "$line"; do
		prompt "Please enter a valid username:"
	done

	USERNAME=$line

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

function getPassword() {
	prompt "Please enter a new password:"
	PASSWORD=$(hashPassword $USERNAME $line)

	prompt "Please enter the password again:"
	[ "$(hashPassword $USERNAME $line)" = "$PASSWORD" ]
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

function runPrompt() {	
	
	readArgs
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

