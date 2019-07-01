#!/usr/bin/env bash

CERT_PATH="/etc/letsencrypt/live/${APP_DOMAIN}/"

if [ ! -d "$CERT_PATH" ]; then
    mkdir -p $CERT_PATH
    openssl req -x509 -nodes -newkey rsa:1024 -days 1 \
        -keyout "$CERT_PATH/privkey.pem" \
        -out "$CERT_PATH/fullchain.pem" \
        -subj "/CN=localhost"
fi