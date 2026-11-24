# Архитектура

Foreman VM разделяет публичный и provisioning-контуры. Broadcast DHCP не выходит за пределы Host-only сети.

| Узел | Интерфейс | Адрес | Назначение |
|---|---|---:|---|
| foreman-server | enp0s3 | 10.0.2.15/24 | VirtualBox NAT, обновления и внешние зеркала |
| foreman-server | enp0s8 | 192.168.56.10/24 | DHCP, DNS, TFTP, HTTPBoot, gateway |
| alma-node01 | enp0s3 | 192.168.56.150/24 | Единственный managed/provisioning NIC |

Поток установки:

1. BIOS PXE получает lease/reservation и TFTP loader от Smart Proxy.
2. PXELinux загружает kernel и initrd.
3. Kernel получает Kickstart по Foreman unattended URL.
4. Stage2 загружается локально с `192.168.56.10:8080`.
5. Anaconda выполняет unattended install и provisioning `%post`.
6. Host Group наследует Ansible role.
7. Foreman Remote Execution запускает роль от пользователя `ansible` с sudo.

DNS-зона `lab.test` обслуживается локальным BIND. Сам Foreman использует `127.0.0.1` как resolver, поэтому Foreman Proxy разрешает managed FQDN без зависимости от домашнего роутера/VPN.

