#!/usr/bin/env bash

echo "Provisioning app ..."

# Create necessary directories if missing and fix permissions
echo "Creating necessary directories ..."
mkdir -p /app/web/app/uploads
echo "Setting permisssions ..."
chmod -R 777 /app/web/app/uploads

# Execute as user application
su application << 'EOSU'

mkdir -p ~/.ssh
chmod 700 ~/.ssh
ssh-keyscan -t rsa,dsa github.com >> ~/.ssh/known_hosts

CMD_APP="vendor/bin/wp"

APP_CHECK_INSTALLED="${CMD_APP} core is-installed"
if eval $APP_CHECK_INSTALLED; then
  echo "App already installed."
else
  echo "App not installed."
  echo "Installing app ..."
  $CMD_APP core install --url=${APP_WP_HOME} --title=Courses --admin_user=hhva --admin_password=secret --admin_email=helmuthva@googlemail.com --skip-email
  if eval $APP_CHECK_INSTALLED; then
    echo "Installing app done."
  else
    echo "Installing app failed."
  fi
fi

## Dump autoloader
echo "Dumping optimized autoloader"
cd /app && composer dump-autoload -o --apcu

## Switch back to root
EOSU

## Fix permissions again
echo "Fixing permisssions again ..."
chmod -R 777 /app/web/app/uploads

echo "Provisioning app done."

echo "Booting up services  ..."
