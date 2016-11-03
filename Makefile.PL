use inc::Module::Install;

name 'dh-waf';
version '1.0';

install_script 'dh_waf';

#postamble <<'END_OF_MAKEFILE';
#install:: extra_install
#pure_install:: extra_install
#install_vendor:: extra_install
#
#extra_install:
#	install -d $(DESTDIR)/usr/share/debhelper/autoscripts
#	install -m 640 autoscripts/* $(DESTDIR)/usr/share/debhelper/autoscripts
#END_OF_MAKEFILE

WriteAll;
