#!/usr/bin/env bash

go-replace \
        -s "<APP_CDN_DOMAIN>" -r "${APP_CDN_DOMAIN}" \
        -- "/etc/nginx/includes.d/pagespeed.conf"