#!/bin/bash

# Start client
openssl s_client -connect localhost:5557 -quiet -verify_quiet

