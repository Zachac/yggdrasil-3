#!/usr/bin/perl

use strict;
use warnings;

use lib::model::player;
use lib::model::commands;

my $command = shift;

unless (@ARGV > 0) {
    print "usage: $command location\n";
    return 1;
}

player::setLocation($ENV{'USERNAME'}, "@ARGV");
commands::runCommand("look");
