SHELL = /bin/bash
# makefile for creating packages out of my tarball
VERSION := ${shell cat VERSION}
TMPDIR := $(shell mktemp -d /tmp/Gooseproject-ssh-XXXX)
RPMBUILDDIR := ~/rpmbuild
SOURCESDIR = $(RPMBUILDDIR)/SOURCES
TARBALL := $(SOURCESDIR)/Gooseproject-ssh-authorized-$(VERSION).tgz
SPECDIR = $(RPMBUILDDIR)/SPECS
SPECFILE := $(SPECDIR)/Gooseproject-ssh-authorized.spec
SPECTEMP = src/redhat/Gooseproject-ssh-authorized.spec.template

all: rpm
	@echo made all

$(SPECFILE): $(SPECTEMP)
	@cat $(SPECTEMP) | sed -e "s/__VERSION__/$$(cat VERSION)/g" > $(SPECFILE)
	@echo made specfile

$(TARBALL): src/common/makefile
	@mkdir -p $(TMPDIR)/Gooseproject-ssh-authorized-$(VERSION)
	@cp -a src/common/* $(TMPDIR)/Gooseproject-ssh-authorized-$(VERSION)
	@tar -czf $(TARBALL) -C $(TMPDIR)  Gooseproject-ssh-authorized-$(VERSION)/
	@rm -rf $(TMPDIR)
	@echo made tarball $(TARBALL)

rpm: $(TARBALL) $(SPECFILE)
	rpmbuild -ba $(SPECFILE)
	@echo created Gooseproject-rpm version $(VERSION)

clean:
	rm -rf $(TARBALL) $(SPECFILE) /tmp/Gooseproject-ssh-* rpmbuild/RPMS/*/*.rpm rpmbuild/SRPMS/*.src.rpm rpmbuild/BUILD/*

rpminstall: clean rpm
	rpm -Uvh rpmbuild/RPMS/noarch/Gooseproject-ssh-authorized*.noarch.rpm

rpmuninstall:
	rpm -e Gooseproject-ssh-authorized
