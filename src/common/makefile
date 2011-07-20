DESTDIR ?= /

all: VERSION authorized_keys2
	@echo "making all"

authorized_keys2: templates/auth_keys_*.txt ssh-keys/*
	@echo "creating auth_keys file"
	@cat templates/auth_keys_header.txt > authorized_keys2
	@for i in ssh-keys/*; do echo -n "environment=\"AUDIT_USER=$$(echo $$i | sed -e 's/ssh-keys\/\(.*\)_.*$$/\1/')\" " >> authorized_keys2; cat $$i >> authorized_keys2; done
	@cat templates/auth_keys_footer.txt >> authorized_keys2

clean:
	rm -f authorized_keys*

install: all
	@echo "running install in $(DESTDIR)"
	@mkdir -p $(DESTDIR)/root/.ssh/
	@install -m 0640 -o root -g root authorized_keys2 $(DESTDIR)/root/.ssh/
	@cd $(DESTDIR)/root/.ssh/ && ln -s authorized_keys2 authorized_keys
