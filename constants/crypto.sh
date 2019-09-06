#!/bin/bash


function hashPassword() {
	openssl dgst -sha256 -binary <<< "$*" | base64 -w0
}
