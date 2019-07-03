#!/usr/bin/env bash

echo "Provisioning app ..."

# Create necessary directories if missing and fix permissions
echo "Creating necessary directories ..."
mkdir -p /app/pub/app/uploads
mkdir -p /app/pub/app/cache
echo "Setting permisssions ..."
chmod -R 777 /app/pub/app/uploads
chmod -R 777 /app/pub/app/cache

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

echo "Configure URL rewriting ..."
$CMD_APP rewrite structure "/%postname%"

echo "Activating plugins ..."
$CMD_APP plugin activate better-search-replace
$CMD_APP plugin activate broken-link-checker
$CMD_APP plugin activate elementor
$CMD_APP plugin activate regenerate-thumbnails
$CMD_APP plugin activate simple-image-sizes
$CMD_APP plugin activate w3-total-cache
$CMD_APP plugin activate wordpress-seo

if [ "$APP_STAGE" = "production" ]
then

    echo "Activating plugins for production ..."

fi

echo "Activating theme ..."
$CMD_APP theme activate hestia

echo "Injecting stage specific settings ..."
cp -f /app/pub/app/w3tc-config/master.$APP_STAGE.php /app/pub/app/w3tc-config/master.php

echo "Dumping optimized autoloader ..."
cd /app && composer dump-autoload -o --apcu

## Switch back to root
EOSU

## Fix permissions again
echo "Fixing permisssions again ..."
chmod -R 777 /app/pub/app/uploads
chmod -R 777 /app/pub/app/cache

echo "Provisioning app done."

echo "Booting up services  ..."
