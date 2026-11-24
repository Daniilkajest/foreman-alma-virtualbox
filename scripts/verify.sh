#!/usr/bin/env bash
set -euo pipefail

HOST="${HOST:-alma-node01.lab.test}"
SSH_USER="${SSH_USER:-ansible}"
KEY="${KEY:-/usr/share/foreman-proxy/.ssh/id_ed25519}"

getent hosts "${HOST}"
sudo -u foreman-proxy -H ansible all \
  -i "${HOST}," -u "${SSH_USER}" --private-key "${KEY}" -b -m ping
sudo -u foreman-proxy -H ssh -i "${KEY}" "${SSH_USER}@${HOST}" \
  'timedatectl show -p NTPSynchronized --value; systemctl is-active chronyd; chronyc tracking; sudo sshd -T | grep ^permitrootlogin'

