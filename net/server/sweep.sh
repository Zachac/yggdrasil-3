#!/bin/bash

source "$( dirname "${BASH_SOURCE[0]}" )/../../PATHS" || exit


function cleanup() {

	

	rm "$USERS/$1/proc"
	rm $p
	
}

for p in $RUNTIME/server/players/* ; do
	if [ -L "$p" ]; then
		proc=$(cat "$(realpath "$p")/proc")
		if ! kill -s 0 "$proc"; then
			cleanup $(basename "$p")
		fi
	fi
done



