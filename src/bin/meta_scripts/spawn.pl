#!/usr/bin/perl

use strict;
use warnings;

use lib::model::user::user;
use lib::model::commands;

my $command = shift;
my $location;

$location = "@ARGV" if (@ARGV > 0);

user::spawn($ENV{'USERNAME'}, $location);

commands::runNoNewLine('look');

1;