#!/bin/bash

# Start client
openssl s_client -connect localhost:3329 -quiet -verify_quiet

