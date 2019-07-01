#!/usr/bin/env bash
echo 'Europe/Berlin' > /etc/timezone
rm /etc/localtime
dpkg-reconfigure -f noninteractive tzdata