#!/usr/bin/env bash
set -euo pipefail

PUBLIC_IF="${PUBLIC_IF:-enp0s3}"
PRIVATE_IF="${PRIVATE_IF:-enp0s8}"
POLICY="${POLICY:-prov2pub}"

sudo sysctl -w net.ipv4.ip_forward=1
printf '%s\n' 'net.ipv4.ip_forward = 1' | sudo tee /etc/sysctl.d/90-foreman-router.conf >/dev/null

sudo firewall-cmd --permanent --zone=public --change-interface="${PUBLIC_IF}"
sudo firewall-cmd --permanent --zone=provisioning --change-interface="${PRIVATE_IF}"
sudo firewall-cmd --permanent --zone=public --add-masquerade

if ! sudo firewall-cmd --permanent --get-policies | tr ' ' '\n' | grep -qx "${POLICY}"; then
  sudo firewall-cmd --permanent --new-policy="${POLICY}"
fi
sudo firewall-cmd --permanent --policy="${POLICY}" --add-ingress-zone=provisioning
sudo firewall-cmd --permanent --policy="${POLICY}" --add-egress-zone=public
sudo firewall-cmd --permanent --policy="${POLICY}" --set-target=ACCEPT
sudo firewall-cmd --permanent --zone=provisioning --add-port=8080/tcp
sudo firewall-cmd --reload

sudo firewall-cmd --zone=public --query-masquerade
sudo firewall-cmd --info-policy="${POLICY}"

