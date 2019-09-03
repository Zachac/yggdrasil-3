#!/bin/bash


function isValidUsername() {

    if [ "$#" != 1 ]; then
        echo "Username cannot contain spaces"
        return 3
	elif ! grep -q '^[a-zA-Z0-9]*$' <<< "$1"; then
		echo "Username contains invalid charachters"
		return 1
	elif [ ${#1} -lt 1 ] || [ ${#1} -gt 16 ]; then
		echo "Username must be between 1-16 charachters in length"
		return 2
	else
		return 0
	fi

}

function validateUser() {
	prompt "Please enter your password:"
    PASSWORD=$(hashPassword "$USERNAME" "$line")
	[ "$(cat "$USERS/$USERNAME/password")" = "$PASSWORD" ]
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
