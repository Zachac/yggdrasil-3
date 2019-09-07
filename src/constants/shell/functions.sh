#!/bin/bash

function hashPassword() {
	openssl dgst -sha256 -binary <<< "$*" | base64 -w0
}

function roomPath() {
    echo -n "$ROOMS/$*"
}

function roomExists() {
    [ -e "$*/description" ]
}

function roomCreate() {
		mkdir -p "$*"
		echo "It looks like a normal room." > "$*/description"
}
