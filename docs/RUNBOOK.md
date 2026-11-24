# Runbook

## VirtualBox

- `foreman-server`: Adapter 1 NAT, Adapter 2 Host-only.
- `alma-node01`: только Adapter 1 Host-only, Intel PRO/1000 MT Desktop, cable connected.
- VirtualBox DHCP на Host-only сети выключен.
- Alma node: 4 GiB RAM, 2 vCPU, legacy BIOS, Network перед Disk на время provisioning.

## Foreman objects

- Domain: `lab.test`.
- Subnet: `192.168.56.0/24`, gateway/DNS `192.168.56.10`.
- Host Group: `linux-base`.
- OS: AlmaLinux 9.9, x86_64.
- Loader доказанного стенда: PXELinux BIOS.
- Host: `alma-node01.lab.test`, `192.168.56.150`, MAC `08:00:27:81:82:e9`.

## NTP snippet

Импортировать `foreman-templates/almalinux_ntp_post.erb` и `foreman-templates/kickstart_default_custom_post.erb` как snippets. Стандартный `Kickstart default` уже вызывает extension point `Kickstart default custom post`, поэтому vendor template не требуется форкать. Параметры Host Group:

```text
ntp_servers = 0.pool.ntp.org,1.pool.ntp.org
timezone = Europe/Moscow
```

## Ansible

Скопировать `ansible/roles/disable_root_login` в `/etc/ansible/roles/`, импортировать через `Configure > Ansible > Roles`, назначить Host Group `linux-base`.

Параметры Host Group:

```text
ansible_user = ansible
ansible_become = true
ansible_ssh_private_key_file = /usr/share/foreman-proxy/.ssh/id_ed25519
remote_execution_ssh_user = ansible
```

Запуск: `Jobs > Run job > Ansible Playbook > Ansible Roles - Ansible Default`.

## Acceptance

```bash
sudo HOST=alma-node01.lab.test ./scripts/verify.sh
```

Ожидается: Ansible `pong`, Chrony active/synchronized и `permitrootlogin no`.

