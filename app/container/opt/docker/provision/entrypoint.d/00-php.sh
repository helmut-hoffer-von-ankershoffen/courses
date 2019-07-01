#!/usr/bin/env bash

echo "provisioning php ..."

go-replace \
    -s "<PHP_DISPLAY_ERRORS>" -r "$PHP_DISPLAY_ERRORS" \
    -- "/opt/docker/etc/php/php.ini"

echo "provisioning php done."
