#!/usr/bin/env bash

echo "Provisioning app ..."

# Create necessary directories if missing
echo "Creating necessary directories ..."
mkdir -p /app/var

## Fix permissions
echo "Setting permisssions ..."
chmod -R 777 /app/var

# Execute as user application
su application << 'EOSU'

CMD_APP="php /app/bin/app"

mkdir -p ~/.ssh
chmod 700 ~/.ssh
ssh-keyscan -t rsa,dsa github.com >> ~/.ssh/known_hosts

## Inject environment
echo "Injecting env.php for development..."
#cp /app/app/etc/env.development.php /app/app/etc/env.php
#chmod 777 /app/app/etc/env.php

## Dump autoloader
echo "Dumping optimized autoloader"
cd /app && composer dump-autoload -o --apcu

## Switch back to root
EOSU

## Fix permissions again
echo "Setting permisssions again ..."
chmod -R 777 /app/var

echo "Provisioning app done."

echo "Booting up services  ..."
