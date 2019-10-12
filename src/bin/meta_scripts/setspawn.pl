#!/usr/bin/perl

use strict;
use warnings;

use lib::model::user;
use lib::model::commands;

my $command = shift;
my $location;

$location = "@ARGV" if (@ARGV > 0);

die "unable to set spawn!\n" unless (user::setSpawn($ENV{'USERNAME'}, $location));

print "spawn set!\n";

1;