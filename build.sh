cd /mnt/net-snmp-5.9.3
# ./configure \
# 	--with-install-prefix=/mnt/target \
# 	--disable-manuals \
# 	--disable-agent \
# 	--disable-as-needed \
# 	--disable-debugging \
# 	--with-perl-modules=INSTALL_BASE=/mnt/target \
# 	--with-security-modules=usm,ksm,tsm \
# 	--with-default-snmp-version="2" \
# 	--with-sys-contact="dev@zenoss.com" \
# 	--with-sys-location="nowhere" \
# 	--with-logfile=/var/log/snmpd.log \
# 	--with-persistent-directory=/var/net-snmp

./configure \
	--build=x86_64-redhat-linux-gnu \
	--host=x86_64-redhat-linux-gnu \
	--program-prefix= \
	--prefix=/usr \
	--exec-prefix=/usr \
	--bindir=/usr/bin \
	--sbindir=/usr/sbin \
	--datadir=/usr/share \
	--includedir=/usr/include \
	--libdir=/usr/lib64 \
	--libexecdir=/usr/libexec \
	--localstatedir=/var \
	--sharedstatedir=/var/lib \
	--mandir=/usr/share/man \
	--infodir=/usr/share/info \
	--disable-static \
	--enable-shared \
	--enable-as-needed \
	--enable-blumenthal-aes \
	--enable-embedded-perl \
	--enable-ipv6 \
	--enable-local-smux \
	--enable-mfd-rewrites \
	--enable-ucd-snmp-compatibility \
	--sysconfdir=/etc \
	--with-cflags='%CFLAGS%' \
 	--with-default-snmp-version="2" \
 	--with-install-prefix=/mnt/target \
	--with-ldflags='%LDFLAGS%' \
	--with-logfile=/var/log/snmpd.log \
	--with-mib-modules='%MIBS%' \
	--with-openssl \
	--with-persistent-directory=/var/lib/net-snmp \
 	--with-perl-modules=INSTALLDIR=vendor \
	--with-pic \
	--with-security-modules=tsm \
	--with-sys-location=Unknown \
	--with-sys-contact=root@localhost \
	--with-temp-file-pattern=/run/net-snmp/snmp-tmp-XXXXXX \
	--with-transports='DTLSUDP TLSTCP' \
	build_alias=x86_64-redhat-linux-gnu \
	host_alias=x86_64-redhat-linux-gnu \
	CFLAGS='%CFLAGS%' \
	LDFLAGS='-Wl,-z,relro -Wl,-z,now -specs=/usr/lib/rpm/redhat/redhat-hardened-ld' \
	PKG_CONFIG_PATH=:/usr/lib64/pkgconfig:/usr/share/pkgconfig
