#!/usr/bin/perl

use strict;
use warnings;

use lib::model::meta_scripts;

my $command = shift;

die "usage: $command meta_script [args]\n" unless (@ARGV > 0);

meta_scripts::execute(@ARGV);
