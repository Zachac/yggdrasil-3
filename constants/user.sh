#!/bin/bash


function cleanUser() {
    USERNAME="$1"
	
	# ignore warnings for this as if they quit normally,
	# this file will have already been cleaned up
	rm "$ROOMS/$(load user location)/players/$1" 2>/dev/null
	
	rm "$USERS/$1/proc"
	rm "$CONNECTED_PLAYERS/$1"
}

function userProcAlive() {
	# check if the process is alive by sending a no-op signal
	# through the kill command. If the process has already
	# terminated, then kill will end unsuccessfully and we
	# can ignore any warnings that the failed kill generates. 
    kill -s 0 "$(cat "$USERS/$1/proc")" 2>/dev/null
}