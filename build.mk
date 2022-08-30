include versions.mk

DESTDIR = target
SOURCE_ARTIFACT = net-snmp-$(VERSION).tar.gz
SOURCE_URL = http://zenpip.zenoss.eng/packages/$(SOURCE_ARTIFACT)

.PHONY: build clean
.DEFAULT_GOAL := build

build: $(DESTDIR)/usr/bin/snmpget

clean:
	@rm -rf src $(DESTDIR) configure.sh

src $(DESTDIR):
	@mkdir $@

$(DESTDIR)/usr/bin/snmpget: src/apps/snmpget | $(DESTDIR)
	@make -C src install

src/apps/snmpget: src/Makefile | src
	@make -C src

src/Makefile: configure.sh src/configure | src
	@bash ./configure.sh src

configure.sh: configure.sh.in
	@sed \
		-e "s|%MIBS%|$(shell cat mibs.txt)|g" \
		-e "s|%CFLAGS%|$(shell cat cflags.txt)|g" \
		-e "s|%LDFLAGS%|$(shell cat ldflags.txt)|g" \
		-e "s|%LDFLAGS2%|$(shell cat ldflags2.txt)|g" \
		-e "s|%TARGET%|/mnt/$(DESTDIR)|g" \
		$< > $@

src/configure: | src
	@wget -nv $(SOURCE_URL) -O - | tar -zx --strip-components=1 -C src
