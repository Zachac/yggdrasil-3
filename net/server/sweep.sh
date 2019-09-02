#!/bin/bash

source "$( dirname "${BASH_SOURCE[0]}" )/../../PATHS" || exit


function cleanup() {
	USERNAME=$1
	rm "$ROOMS/$(load user location)/players/$1"
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



