#!/usr/bin/env bash

go-replace \
        -s "<APP_CERTBOT_NAME>" -r "${APP_CERTBOT_NAME}" \
        -s "<APP_CERTBOT_DOMAINS>" -r "${APP_CERTBOT_DOMAINS}" \
        -s "<APP_CERTBOT_EMAIL>" -r "${APP_CERTBOT_EMAIL}" \
        -- "/etc/cron.daily/cert-renewal.sh"