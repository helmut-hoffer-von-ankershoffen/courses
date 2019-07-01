#!/usr/bin/env bash

rm -f /etc/nginx/sites-enabled/*

ln -sf /etc/nginx/sites-available/default.conf /etc/nginx/sites-enabled/
ln -sf /etc/nginx/sites-available/monitoring.conf /etc/nginx/sites-enabled/
ln -sf /etc/nginx/sites-available/app.conf /etc/nginx/sites-enabled/
