# Evidence checklist

Перед сдачей положить обезличенные скриншоты в `screenshots/`:

1. VirtualBox: Foreman NAT + Host-only и Alma только Host-only.
2. Smart Proxy features: DHCP, DNS, TFTP, HTTPBoot, Ansible, Dynflow, Script.
3. Subnet `192.168.56.0/24` и proxies.
4. Host Group `linux-base`, OS и assigned Ansible role.
5. Managed host: FQDN, IP `.150`, MAC, AlmaLinux 9.9.
6. Anaconda `Starting automated install` и package installation.
7. Установленная AlmaLinux login prompt.
8. `timedatectl`/`chronyc tracking` на node.
9. Foreman Job `Succeeded 1/1`.
10. `sshd -T`: `permitrootlogin no`.

Удалить/замазать пароли, build tokens, private keys и reset-password output.

