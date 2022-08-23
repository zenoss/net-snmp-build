.SHELL = bash

include versions.mk

NAME        := net-snmp
RELEASE     := $(PACKAGE_VERSION).el7_9
CATEGORY    := Applications/System
SUMMARY     := A collection of SNMP protocol tools and libraries
URL         := http://net-snmp.sourceforge.net/
LICENSE     := BSD
PACKAGER    := Zenoss, Inc. <http://zenoss.com>
DESCRIPTION := SNMP (Simple Network Management Protocol) is a protocol used for network management. The NET-SNMP project includes various SNMP tools, an extensible agent, an SNMP library, tools for requesting or setting, information from SNMP agents, tools for generating and handling SNMP, traps, a version of the netstat command which uses SNMP, and a Tk/Perl, mib browser. This package contains the snmpd and snmptrapd daemons, documentation, etc.

PKG_NAME = $(NAME)-$(VERSION)
PWD = $(shell pwd)
BUILD_DIR = $(PWD)/src
SRC_DIR = $(PWD)/target
PKG_DIR = $(PWD)/pkg

USR_DIR = usr
SHARE_DIR = $(USR_DIR)/share

BIN_DIR = $(USR_DIR)/bin
SBIN_DIR = $(USR_DIR)/sbin
LIB_DIR = $(USR_DIR)/lib64

MIBS_DIR = $(SHARE_DIR)/mibs
DOC_DIR = $(SHARE_DIR)/doc/net-snmp-$(VERSION)

RPM = $(NAME)-$(VERSION)-$(RELEASE).x86_64.rpm

BIN_FILES = \
	encode_keychange \
	snmpbulkget \
	snmpbulkwalk \
	snmpdelta \
	snmpdf \
	snmpget \
	snmpgetnext \
	snmpinform \
	snmpnetstat \
	snmpset \
	snmpstatus \
	snmptable \
	snmptest \
	snmptls \
	snmptranslate \
	snmptrap \
	snmpusm \
	snmpvacm \
	snmpwalk \
	agentxtrap \
	net-snmp-create-v3-user \
	snmpconf
BIN_FILEPATHS = $(addprefix $(BIN_DIR)/,$(BIN_FILES))

SBIN_FILES = snmpd snmptrapd
SBIN_FILEPATHS = $(addprefix $(SBIN_DIR)/,$(SBIN_FILES))

LIB_FILES = \
	libnetsnmp.so.40.2.0 \
	libnetsnmp.so.40 \
	libnetsnmp.so \
	libnetsnmpagent.so.40.2.0 \
	libnetsnmpagent.so.40 \
	libnetsnmpagent.so \
	libnetsnmphelpers.so.40.2.0 \
	libnetsnmphelpers.so.40 \
	libnetsnmphelpers.so \
	libnetsnmpmibs.so.40.2.0 \
	libnetsnmpmibs.so.40 \
	libnetsnmpmibs.so \
	libnetsnmptrapd.so.40.2.0 \
	libnetsnmptrapd.so.40 \
	libnetsnmptrapd.so
LIB_FILEPATHS = $(addprefix $(LIB_DIR)/,$(LIB_FILES))

DOC_FILES = \
	CHANGES.trimmed \
	COPYING \
	FAQ \
	NEWS \
	README \
	README.agent-mibs \
	README.agentx \
	README.krb5 \
	README.snmpv3 \
	README.thread \
	TODO
DOC_FILEPATHS = $(addprefix $(DOC_DIR)/,$(DOC_FILES))

SNMPCONF_DATA_DIR = $(SHARE_DIR)/snmp/snmpconf-data
SNMP_DATA_DIR = $(SNMPCONF_DATA_DIR)/snmp-data
SNMPD_DATA_DIR = $(SNMPCONF_DATA_DIR)/snmpd-data
TRAPD_DATA_DIR = $(SNMPCONF_DATA_DIR)/snmptrapd-data

SNMP_DATA_FILES = authopts debugging mibs output snmpconf-config
SNMP_DATA_FILEPATHS = $(addprefix $(SNMP_DATA_DIR)/,$(SNMP_DATA_FILES))

SNMPD_DATA_FILES = acl basic_setup extending monitor operation snmpconf-config system trapsinks
SNMPD_DATA_FILEPATHS = $(addprefix $(SNMPD_DATA_DIR)/,$(SNMPD_DATA_FILES))

TRAPD_DATA_FILES = authentication formatting logging runtime snmpconf-config traphandle
TRAPD_DATA_FILEPATHS = $(addprefix $(TRAPD_DATA_DIR)/,$(TRAPD_DATA_FILES))

BIN_TARGETS = $(addprefix $(PKG_DIR)/,$(BIN_FILEPATHS))
SBIN_TARGETS = $(addprefix $(PKG_DIR)/,$(SBIN_FILEPATHS))
LIB_TARGETS = $(addprefix $(PKG_DIR)/,$(LIB_FILEPATHS))
DOC_TARGETS = $(addprefix $(PKG_DIR)/,$(DOC_FILEPATHS))
SNMP_DATA_TARGETS = $(addprefix $(PKG_DIR)/,$(SNMP_DATA_FILEPATHS))
SNMPD_DATA_TARGETS = $(addprefix $(PKG_DIR)/,$(SNMPD_DATA_FILEPATHS))
TRAPD_DATA_TARGETS = $(addprefix $(PKG_DIR)/,$(TRAPD_DATA_FILEPATHS))

.PHONY: rpm
.DEFAULT_GOAL := rpm

rpm: $(RPM)

clean:
	rm -f $(RPM)
	rm -rf $(PKG_DIR)

$(PKG_DIR)/$(PKG_DIR) $(PKG_DIR)/$(DOC_DIR) $(PKG_DIR)/$(BIN_DIR) $(PKG_DIR)/$(SBIN_DIR) $(PKG_DIR)/$(LIB_DIR) $(PKG_DIR)/$(SNMP_DATA_DIR) $(PKG_DIR)/$(SNMPD_DATA_DIR) $(PKG_DIR)/$(TRAPD_DATA_DIR):
	@mkdir -p $@

$(RPM): $(BIN_TARGETS) $(SBIN_TARGETS) $(LIB_TARGETS) $(DOC_TARGETS) $(SNMP_DATA_TARGETS) $(SNMPD_DATA_TARGETS) $(TRAPD_DATA_TARGETS)
	fpm \
		--verbose \
		-t rpm \
		-s dir \
		-C $(PKG_DIR) \
		-n $(NAME) \
		-v $(VERSION) \
		--iteration $(RELEASE) \
		-m '$(PACKAGER)' \
		-p ./ \
		-d coreutils \
		-d glibc \
		-d lm_sensors-libs \
		-d openssl-libs \
		-d perl \
		-d perl-Data-Dumper \
		-d perl-libs \
		-d tcp_wrappers-libs \
		-d zlib \
		--license bsd \
		--after-install after-install.sh \
		--replaces net-snmp-libs \
		--replaces net-snmp-utils \
		--replaces net-snmp-agent-libs \
		--replaces 'net-snmp<5.9.3' \
		--category '$(CATEGORY)' \
		--description '$(DESCRIPTION)' \
		--license '$(LICENSE)' \
		--vendor '$(VENDOR)' \
		--url '$(URL)' \
		--provides $(NAME) \
		--rpm-summary '$(SUMMARY)' \
		--rpm-user root \
		--rpm-group root \
		usr

$(BIN_TARGETS) $(SBIN_TARGETS) $(LIB_TARGETS) $(SNMP_DATA_TARGETS) $(SNMPD_DATA_TARGETS) $(TRAPD_DATA_TARGETS): | $(PKG_DIR)/$(BIN_DIR) $(PKG_DIR)/$(SBIN_DIR) $(PKG_DIR)/$(LIB_DIR) $(PKG_DIR)/$(SNMP_DATA_DIR) $(PKG_DIR)/$(SNMPD_DATA_DIR) $(PKG_DIR)/$(TRAPD_DATA_DIR)

$(BIN_TARGETS) $(SBIN_TARGETS) $(LIB_TARGETS): $(PKG_DIR)/%: $(SRC_DIR)/%
	@cp --no-dereference --preserve=mode,timestamps,links $< $@
	@FILETYPE=$$(file -ib $@); if [[ "$$FILETYPE" =~ application/x-executable*|application/x-sharedlib* ]]; then strip $@; fi

$(SNMP_DATA_TARGETS) $(SNMPD_DATA_TARGETS) $(TRAPD_DATA_TARGETS): $(PKG_DIR)/%: $(SRC_DIR)/%
	@cp --no-dereference --preserve=mode,timestamps,links $< $@

$(DOC_TARGETS): | $(PKG_DIR)/$(DOC_DIR)
$(DOC_TARGETS): $(PKG_DIR)/$(DOC_DIR)/%: $(BUILD_DIR)/%
	@cp --no-dereference --preserve=mode,timestamps,links $< $@

$(BUILD_DIR)/CHANGES.trimmed: $(BUILD_DIR)/CHANGES
	@echo sed -n "/\*5\.7\.2\*/q;p" $< > $@
