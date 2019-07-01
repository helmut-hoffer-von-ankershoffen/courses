#!/usr/bin/env bash

echo "Provisioning app ..."

# Execute as user application
su application << 'EOSU'

mkdir -p ~/.ssh
chmod 700 ~/.ssh
ssh-keyscan -t rsa,dsa github.com >> ~/.ssh/known_hosts

if [! $(vendor/bin/wp core is-installed)]; then
  vendor/bin/wp core install --url=${APP_WP_HOME} --title=Courses --admin_user=hhva --admin_password=secret --admin_email=helmuthva@googlemail.com --skip-email
fi

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
