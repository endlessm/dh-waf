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

sub waf_doit {
	my $this = shift @_;
	my $cmd = shift @_;
	return doit('./waf', $cmd,  @_);
}

sub configure {
	my $this=shift;
	return $this->waf_doit('configure', '--prefix=/usr');
}

sub build {
	my $this=shift;
	return $this->waf_doit('build');
}

sub install {
	my $this=shift;
	my $destdir=shift;
	return $this->waf_doit('install', '--destdir='.$destdir)
}

sub test {
	my $this=shift;
	return print "WAF does not support test yet"
#	return $this->waf_doit('test');
}

sub clean {
	my $this=shift;
	eval { $this->waf_doit('clean') }; warn $@ if $@;
	doit('rm', '-rf', 'build/*', 'build/.conf*', 'build/.waf*', '.waf*');
	# hack, proper git clean when on git…
	doit('git', 'clean', '-dfx');
	doit('find', '.', '-name', '*.pyc', '-exec', 'rm', '{}', ';');
}

1
