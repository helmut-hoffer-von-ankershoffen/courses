#!/usr/bin/env bash

certbot --nginx --non-interactive --agree-tos -m <APP_CERTBOT_EMAIL> --cert-name <APP_CERTBOT_NAME> <APP_CERTBOT_DOMAINS>