#!/bin/bash

function save() {
	if [ ! "$#" -eq 2 ]; then
		echo "ERROR: Save expects arguments length 2"
		return 1
	elif [ -z "$2" ] || [ -z "${!2}" ]; then
		echo "ERROR: Reference to save not found $2: ${!2}"
		return 2
	fi


	if [ "${1,,}" = "user" ]; then
		if [ -z "$USERNAME" ]; then
			echo "ERROR: \$USERNAME not set"
			return 5
		fi

		basePath="$USERS/$USERNAME"
	else
		echo "ERROR: Unkown variable owner type $1"
		return 3
	fi


	if [ ! -d "$basePath" ]; then
		echo "ERROR: Base directory does not exist $basePath"
		return 4
	fi

	echo -n "${!2}" > "$basePath/$2"
}


function load() {

	if [ ! "$#" -eq 2 ]; then 
		echo "ERROR: Load expects arguments length 2" >&2
		exit 1
	elif [ -z "$2" ]; then 
		echo "ERROR: Reference to load not given: $2" >&2
		exit 2
	fi

	if [ "${1,,}" = "user" ]; then
		if [ -z $USERNAME ]; then
			echo "ERROR: \$USERNAME not set"
			exit 5
		fi

		path="$USERS/$USERNAME/$2"
	else
		echo "ERROR: Unkown variable owner type $1"
		exit 3
	fi

	if [ ! -f "$path" ]; then
		return 4
	fi

	cat "$path"
}
