# iPXE и VirtualBox

## Наблюдаемое ограничение

Встроенный legacy ROM VirtualBox сообщил:

```text
Features: DNS TFTP PXEXT
Could not start download: Operation not supported
```

То есть firmware умеет TFTP/PXE, но не HTTP. URL Foreman `/unattended/iPXE` исправен, однако такой ROM не может его получить.

## Доказанный fallback

Для завершённой установки выбран `PXELinux BIOS`: firmware использует только TFTP, затем kernel/initrd запускают Anaconda. Это не смешивает public/private сети и сохраняет unattended provisioning.

## Переход на полноценный iPXE

1. Разместить HTTP-capable `undionly.kpxe` в TFTP root Smart Proxy либо подключить iPXE ISO/ROM к VM.
2. В DHCP использовать user-class detection, чтобы первый PXE-клиент получил `undionly.kpxe`, а уже iPXE — Foreman HTTP bootstrap URL. Это предотвращает chain loop.
3. В AlmaLinux OS связать `Kickstart default iPXE`.
4. В Host Group выбрать `iPXE Chain BIOS`.
5. Проверить, что iPXE показывает `HTTP` в Features и получает host-specific template.

В production iPXE бинарник собирается и версионируется централизованно; Secure Boot требует подписанного shim/loader.

