# A debhelper build system class for building waf packages
#
# Copied from dh-python:  © 2012-2013 Piotr Ożarowski
# Copyright: © 2016 Niv Sardi <xaiki@endlessm.com>

# TODO:
# * support for dh --parallel

package Debian::Debhelper::Buildsystem::waf;

use strict;
use Dpkg::Control;
use Dpkg::Changelog::Debian;
use Debian::Debhelper::Dh_Lib qw(error doit doit_noerror verbose_print compat get_buildprefix dpkg_architecture_value);
use base 'Debian::Debhelper::Buildsystem';

sub DESCRIPTION {
	"Build with waf"
}

sub check_auto_buildable {
	my $this=shift;
	return doit_noerror('./waf', '--help');
}

sub new {
	my $class=shift;
	my $this=$class->SUPER::new(@_);
	$this->enforce_in_source_building();

	return $this;
}

sub waf_doit {
	my $this = shift;
	my $cmd = shift;
	return $this->doit_in_builddir('./waf', $cmd,  @_);
}

sub configure {
	my $this=shift;

# Standard set of options for configure.
	my @opts;
	my $prefix=get_buildprefix();

	push @opts, "--prefix=$prefix";
	push @opts, "--includedir=\${prefix}/include";
	push @opts, "--mandir=\${prefix}/share/man";
	push @opts, "--infodir=\${prefix}/share/info";

	if ($prefix eq "/usr") {
		push @opts, "--sysconfdir=/etc";
		push @opts, "--localstatedir=/var";
	} else {
		push @opts, "--sysconfdir=\${prefix}/etc";
		push @opts, "--localstatedir=\${prefix}/var";
	}

	my $multiarch=dpkg_architecture_value("DEB_HOST_MULTIARCH");

	if (! compat(8)) {
	       if (defined $multiarch) {
			push @opts, "--libdir=\${prefix}/lib/$multiarch";
			push @opts, "--libexecdir=\${prefix}/lib/$multiarch";
		}
		else {
			push @opts, "--libexecdir=\${prefix}/lib";
		}
	}
	else {
		push @opts, "--libexecdir=\${prefix}/lib/" . sourcepackage();
	}

	return $this->waf_doit('configure', @opts, @_);
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
	return verbose_print "WAF does not support test yet"
#	return $this->waf_doit('test');
}

sub clean {
	my $this=shift;
	eval { $this->waf_doit('clean') }; warn $@ if $@;
	doit('rm', '-rf', 'build/*', 'build/.conf*', 'build/.waf*', '.waf*');
	doit('find', '.', '-name', '*.pyc', '-exec', 'rm', '{}', '+');
}

1
