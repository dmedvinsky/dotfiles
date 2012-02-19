#!/usr/bin/env sh
domain="$1"
openssl pkcs12 -in "$domain.pfx" -nocerts -nodes -out "$domain.key"
openssl pkcs12 -in "$domain.pfx" -clcerts -nokeys -out "$domain.pem"
