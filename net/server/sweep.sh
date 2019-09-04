#!/bin/bash

for p in "$CONNECTED_PLAYERS/"* ; do
	if [ -f "$p" ]; then
		user="$(basename $p)"

		if ! userProcAlive "$user"; then
			cleanup "$user"
		fi
	fi
done
