#!/usr/bin/env bash
set -euo pipefail

HOST="${HOST:-alma-node01.lab.test}"
SSH_USER="${SSH_USER:-ansible}"
KEY="${KEY:-/usr/share/foreman-proxy/.ssh/id_ed25519}"

getent hosts "${HOST}"

sudo -u foreman-proxy -H ansible all \
  -i "${HOST}," \
  -u "${SSH_USER}" \
  --private-key "${KEY}" \
  -b \
  -m ping

sudo -u foreman-proxy -H ssh \
  -i "${KEY}" \
  "${SSH_USER}@${HOST}" \
  'bash -s' <<'REMOTE'
set -euo pipefail

node_fqdn="$(hostname -f)"
node_ip="$(hostname -I | awk '{print $1}')"
ntp_sync="$(timedatectl show -p NTPSynchronized --value)"
chronyd_state="$(systemctl is-active chronyd || true)"
permit_root="$(sudo /usr/sbin/sshd -T |
  awk '$1 == "permitrootlogin" {print $2}')"

printf 'FQDN=%s\n' "${node_fqdn}"
printf 'IP=%s\n' "${node_ip}"
printf 'NTPSynchronized=%s\n' "${ntp_sync}"
printf 'chronyd=%s\n' "${chronyd_state}"
printf 'permitrootlogin=%s\n' "${permit_root}"

chronyc tracking

[[ "${ntp_sync}" == "yes" ]]
[[ "${chronyd_state}" == "active" ]]
[[ "${permit_root}" == "no" ]]
REMOTE

