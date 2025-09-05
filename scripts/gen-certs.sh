#!/usr/bin/env bash
set -euo pipefail
CN="${1:-localhost}"
mkdir -p certs
openssl req -x509 -nodes -days 365   -newkey rsa:2048   -keyout certs/privkey.pem   -out certs/fullchain.pem   -subj "/CN=${CN}"
echo "Generated certs for CN=${CN} in ./certs"
