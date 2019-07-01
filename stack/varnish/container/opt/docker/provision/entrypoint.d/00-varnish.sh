#!/usr/bin/env bash

if [ "$VARNISH_STAGE" == "production" ]; then
        cp /opt/docker/etc/varnish/includes/backend.production.vcl /opt/docker/etc/varnish/includes/backend.vcl
        go-replace \
        -s "<VARNISH_BACKEND_PROBE_HOST>" -r "$VARNISH_BACKEND_PROBE_HOST" \
        -s "<VARNISH_BACKEND_PROBE_PATH>" -r "$VARNISH_BACKEND_PROBE_PATH" \
        -s "<VARNISH_BACKEND_PROBE_FORWARDED_SCHEME>" -r "$VARNISH_BACKEND_PROBE_FORWARDED_SCHEME" \
        -s "<VARNISH_BACKEND_PROBE_INTERVAL>" -r "$VARNISH_BACKEND_PROBE_INTERVAL" \
        -s "<VARNISH_BACKEND_PROBE_THRESHOLD>" -r "$VARNISH_BACKEND_PROBE_THRESHOLD" \
        -- "/opt/docker/etc/varnish/includes/backend.vcl"

else
        cp /opt/docker/etc/varnish/includes/backend.development.vcl /opt/docker/etc/varnish/includes/backend.vcl
fi

go-replace \
        -s "<VARNISH_BACKEND_MAX_CONNECTIONS>" -r "$VARNISH_BACKEND_MAX_CONNECTIONS" \
        -s "<VARNISH_BACKEND_FIRST_BYTE_TIMEOUT>" -r "$VARNISH_BACKEND_FIRST_BYTE_TIMEOUT" \
        -s "<VARNISH_BACKEND_CONNECT_TIMEOUT>" -r "$VARNISH_BACKEND_CONNECT_TIMEOUT" \
        -s "<VARNISH_BACKEND_BETWEEN_BYTES_TIMEOUT>" -r "$VARNISH_BACKEND_BETWEEN_BYTES_TIMEOUT" \
        -s "<VARNISH_BACKEND_HOST>" -r "$VARNISH_BACKEND_HOST" \
        -s "<VARNISH_BACKEND_PORT>" -r "$VARNISH_BACKEND_PORT" \
        -- "/opt/docker/etc/varnish/includes/backend.vcl"

go-replace \
        -s "<VARNISH_HOST_NEVER_CACHE_REGEX>" -r "$VARNISH_HOST_NEVER_CACHE_REGEX" \
        -- "/opt/docker/etc/varnish/varnish.vcl"