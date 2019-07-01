#!/usr/bin/env bash

go-replace \
        -s "<APP_DOMAIN>" -r "${APP_DOMAIN}" \
        -- "/etc/nginx/sites-available/app.conf"

go-replace \
        -s "<APP_DOMAIN>" -r "${APP_DOMAIN}" \
        -- "/etc/nginx/includes.d/pagespeed.conf"