#!/bin/bash

set -e

NAME=$1
SIZE=${2:-2048}
DAYS=${3:-365}

if [[ -z "$1" || "$1" == "-h" || "$1" == "--help" ]]; then
   echo "Usage: $0 <name> [<size>] [<days>]"
   exit 1
fi

openssl genrsa -out "${NAME}.key" "$SIZE"
openssl req -new -key "${NAME}.key" \
        -out "${NAME}.csr"
openssl x509 -req -days "${DAYS}" -in "${NAME}.csr" \
        -signkey "${NAME}.key" \
        -out "${NAME}.crt"
