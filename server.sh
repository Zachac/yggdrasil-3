#!/bin/bash

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"

echo "Starting server at $DIR"

# Cleanup existing runtime directory
rm -r "$DIR/data/runtime" 2>/dev/null


# Setup files
mkdir "$DIR/data/runtime"


# Start server
openssl s_server -accept 5557 -key data/certs/keyfile.key -cert data/certs/certfile.crt -quiet -verify_quiet

