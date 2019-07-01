#!/usr/bin/env bash

go-replace \
        -s "<MEMCACHED_HOST>" -r "${MEMCACHED_HOST}" \
        -- "/etc/nginx/includes.d/pagespeed.conf"