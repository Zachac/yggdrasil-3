#!/bin/bash

source "$( dirname "${BASH_SOURCE[0]}" )/../../PATHS" || exit


function cleanup() {
	USERNAME="$(basename "$1")"
	rm "$ROOMS/$(load user location)/players/$USERNAME"
	rm "$1/proc"
	rm $p

}

for p in $RUNTIME/server/players/* ; do
	if [ -L "$p" ]; then
		proc=$(cat "$(realpath "$p")/proc")
		if ! kill -s 0 "$proc"; then
			cleanup "$(realpath $p)"
		fi 2>/dev/null
	fi
done



