#!/usr/bin/env bash

echo "Provisioning app ..."

# Create necessary directories if missing
echo "Creating necessary directories ..."
mkdir -p /app/web/app/uploads

## Fix permissions
echo "Setting permisssions ..."
chmod -R 777 /app/web/app/uploads

# Execute as user application
su application << 'EOSU'

CMD_APP="php /app/vendor/bin/wp"

mkdir -p ~/.ssh
chmod 700 ~/.ssh
ssh-keyscan -t rsa,dsa github.com >> ~/.ssh/known_hosts

## Dump autoloader
echo "Dumping optimized autoloader"
cd /app && composer dump-autoload -o --apcu

## Switch back to root
EOSU

## Fix permissions again
echo "Setting permisssions again ..."
chmod -R 777 /app/web/app/uploads

echo "Provisioning app done."

echo "Booting up services  ..."
