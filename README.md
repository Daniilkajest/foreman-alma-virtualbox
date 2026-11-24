# Foreman AlmaLinux provisioning lab

Тестовый стенд автоматической установки AlmaLinux 9.9 в Oracle VM VirtualBox под управлением Foreman 5.0.1.

## Результат

- Foreman/Smart Proxy: `foreman.lab.test`, private IP `192.168.56.10`;
- managed host: `alma-node01.lab.test`, IP `192.168.56.150`;
- изолированная Host-only provisioning-сеть `192.168.56.0/24`;
- DHCP, DNS, TFTP, HTTPBoot, PXELinux и Kickstart управляются Foreman;
- выход private-хостов в интернет выполняется через Foreman NAT;
- NTP/Chrony настраивается provisioning snippet;
- роль `disable_root_login` назначается Host Group `linux-base` и запускается Foreman Remote Execution;
- итог: `permitrootlogin no`, Foreman Job `Succeeded 1/1`.

## Архитектура

```text
Internet
   |
VirtualBox NAT
   |
foreman-server
  enp0s3: 10.0.2.15/24       public zone
  enp0s8: 192.168.56.10/24   provisioning zone
   |
VirtualBox Host-only (VirtualBox DHCP disabled)
   |
alma-node01: 192.168.56.150/24
```

`alma-node01` имеет только один provisioning-интерфейс. Foreman является единственным DHCP/DNS/TFTP authority в private-сети.

## Содержимое

- `ansible/roles/disable_root_login` — идемпотентная роль запрета root SSH;
- `foreman-templates/` — NTP snippet и штатная Kickstart custom-post extension point;
- `systemd/alma-stage2.service` — постоянная локальная раздача stage2;
- `scripts/configure-routing.sh` — forwarding, masquerade и firewalld policy;
- `scripts/install-foreman-ansible.sh` — включение Foreman/Proxy Ansible plugins;
- `scripts/verify.sh` — acceptance-проверки;
- `docs/` — runbook, архитектура, сравнение подходов и перечень доказательств.

## Быстрая проверка

```bash
sudo HOST=alma-node01.lab.test ./scripts/verify.sh
```

Секреты, пароли, build tokens и private SSH keys в репозиторий не входят.

## Важное про iPXE

Встроенный legacy iPXE/PXE ROM VirtualBox в данном стенде объявлял только `DNS TFTP PXEXT` и не поддерживал HTTP (`Operation not supported`). Поэтому доказанная установка выполнена через `PXELinux BIOS`. Архитектура допускает переход на полноценный HTTP-capable iPXE (`undionly.kpxe`/iPXE ISO); процедура описана в `docs/IPXE.md`. Это ограничение firmware VirtualBox, а не Foreman.

