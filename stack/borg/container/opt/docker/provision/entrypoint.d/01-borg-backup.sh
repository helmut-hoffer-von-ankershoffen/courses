#!/usr/bin/env bash

echo "Provisioning borg client ..."

echo "Provisioning borg passphrase ..."
j2 /opt/docker/provision/files/.borg.passphrase.j2 /opt/docker/provision/files/borg.yaml > /root/.borg.passphrase
chmod  700 /root/.borg.passphrase

echo "Provisioning borg wrapper ..."
j2 /opt/docker/provision/files/borg-backup.j2 /opt/docker/provision/files/borg.yaml > /usr/local/bin/borg-backup
chmod  775 /usr/local/bin/borg-backup

echo "Provisioning cron for borg ..."
j2 /opt/docker/provision/files/cron.j2 /opt/docker/provision/files/borg.yaml > /etc/cron.d/borg-backup
chmod  644 /etc/cron.d/borg-backup

echo "Provisioning ssh access ..."
mkdir /root/.ssh
chmod 700 /root/.ssh
j2 /opt/docker/provision/files/config.j2 /opt/docker/provision/files/borg.yaml > /root/.ssh/config
chmod  644 /root/.ssh/config
echo "${BORGBACKUP_RSA_PRIVATE}" > /root/.ssh/id_borg_rsa
chmod 600 /root/.ssh/id_borg_rsa
echo "${BORGBACKUP_RSA_PUBLIC}" > /root/.ssh/id_borg_rsa.public
chmod 644 /root/.ssh/id_borg_rsa.public

echo "Initializing repository on backup server ..."
borg-backup init

echo "Provisioning borg client done."
