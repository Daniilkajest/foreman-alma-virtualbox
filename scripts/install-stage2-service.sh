#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="/var/lib/foreman/public/alma9"
SOURCE_URL="https://mirror.yandex.ru/almalinux/9/BaseOS/x86_64/os"

sudo install -d -o foreman-proxy -g foreman-proxy -m 0755 "${ROOT_DIR}/images"
sudo curl -fL --retry 5 --retry-all-errors -C - \
  -o "${ROOT_DIR}/images/install.img" "${SOURCE_URL}/images/install.img"
sudo curl -fL --retry 5 --retry-all-errors \
  -o "${ROOT_DIR}/.treeinfo" "${SOURCE_URL}/.treeinfo"
sudo chown -R foreman-proxy:foreman-proxy "${ROOT_DIR}"
sudo chmod 0644 "${ROOT_DIR}/.treeinfo" "${ROOT_DIR}/images/install.img"
sudo restorecon -RFv "${ROOT_DIR}"

sudo install -o root -g root -m 0644 \
  systemd/alma-stage2.service /etc/systemd/system/alma-stage2.service
sudo systemctl daemon-reload
sudo systemctl enable --now alma-stage2.service
curl -fsSI http://192.168.56.10:8080/.treeinfo
curl -fsSI http://192.168.56.10:8080/images/install.img

