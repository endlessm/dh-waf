#!/usr/bin/perl
use warnings;
use strict;
use Debian::Debhelper::Dh_Lib;
use Debian::Debhelper::Dh_Buildsystems;

buildsystems_init();
my $bs = load_buildsystem("waf");

1
