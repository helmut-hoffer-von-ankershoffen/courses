#!/usr/bin/env bash

go-replace \
        -s "<APP_UPSTREAM_HOST>" -r "${APP_UPSTREAM_HOST}" \
        -s "<APP_UPSTREAM_PORT>" -r "${APP_UPSTREAM_PORT}" \
        -- "/etc/nginx/sites-available/app.conf"
