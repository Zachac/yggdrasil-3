#!/usr/bin/perl

use strict;
use warnings;

use lib::model::user::user;
use lib::model::commands::commands;

my $command = shift;
my $location;

$location = "@ARGV" if (@ARGV > 0);

die "unable to set spawn!\n" unless (user::setSpawn($ENV{'USERNAME'}, $location));

print "Spawn set!\n";

1;