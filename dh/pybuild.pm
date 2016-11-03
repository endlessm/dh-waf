# A debhelper build system class for building Python libraries
#
# Copyright: © 2012-2013 Piotr Ożarowski

# TODO:
# * support for dh --parallel

package Debian::Debhelper::Buildsystem::waf;

use strict;
use Dpkg::Control;
use Dpkg::Changelog::Debian;
use Debian::Debhelper::Dh_Lib qw(error doit);
use base 'Debian::Debhelper::Buildsystem';

sub DESCRIPTION {
	"Build with waf"
}

sub check_auto_buildable {
	my $this=shift;
	return doit('./waf', '--help');
}

sub new {
	my $class=shift;
	my $this=$class->SUPER::new(@_);
	$this->enforce_in_source_building();

	return $this;
}

sub configure {
	my $this=shift;
	return doit('./waf', 'configure', $ENV{'DEB_CONFIGURE_OPTIONS'});
}

sub build {
	my $this=shift;
	return doit('./waf', 'build');
}

sub install {
	my $this=shift;
	my $destdir=shift;
	return doit('./waf', 'install', '--destdir='.$destdir)
}

sub test {
	my $this=shift;
	return doit('./waf', 'test');
}

sub clean {
	my $this=shift;
	doit('./waf', 'clean');
	doit('rm', '-rf', 'build/*', 'build/.conf*', 'build/.waf*');
	doit('find', '.', '-name', '*.pyc', '-exec', 'rm', '{}', ';');
}

1
