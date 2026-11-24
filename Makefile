.PHONY: validate archive

validate:
	bash -n scripts/*.sh
	@test -f ansible/roles/disable_root_login/tasks/main.yml
	@test -f foreman-templates/almalinux_ntp_post.erb
	@! grep -RniE '(password[[:space:]]*[:=][[:space:]]*[^<]|token=[a-z0-9-]{12,}|BEGIN .*PRIVATE KEY)' . --exclude-dir=.git --exclude=Makefile

archive: validate
	tar --exclude='.git' --exclude='*.tar.gz' -czf foreman-alma-virtualbox.tar.gz .

