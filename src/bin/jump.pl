#!/usr/bin/perl

use strict;
use warnings;

use lib::model::user;
use lib::model::commands;

my $command = shift;

unless (@ARGV > 0) {
    print "usage: $command location\n";
    return 1;
}

user::setLocation($ENV{'USERNAME'}, "@ARGV");
commands::runCommand("look");
