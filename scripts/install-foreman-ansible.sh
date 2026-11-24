#!/usr/bin/env bash
set -euo pipefail

sudo foreman-installer \
  --enable-foreman-plugin-ansible \
  --enable-foreman-proxy-plugin-ansible

hammer ping
rpm -qa | grep -Ei 'foreman.*ansible|ansible.*foreman|smart.proxy.ansible'
ansible --version

