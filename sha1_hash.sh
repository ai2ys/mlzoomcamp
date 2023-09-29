#!/bin/bash

if [ $# -ne 1 ]; then
    echo "Usage: '$0 <string>'"
    exit 1
fi

input_string="$1"
sha1_hash=$(echo -n "$input_string" | openssl dgst -sha1)

echo "SHA-1 hash of '$input_string' is: $sha1_hash"