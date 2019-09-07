#!/bin/bash

function readLine() {
	read line || exit 1
}

function prompt() {
    echo "$*"
    readLine
}

function readArgs() {
    read -ra arguments || exit 1
}

function hashPassword() {
	openssl dgst -sha256 -binary <<< "$*" | base64 -w0
}
