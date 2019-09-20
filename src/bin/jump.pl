#!/usr/bin/perl

use strict;
use warnings;

use lib::model::entity;
use lib::model::commands;

my $command = shift;

unless (@ARGV > 0) {
    print "usage: $command location\n";
    return 1;
}

entity::setLocation("@ARGV", 'player', $ENV{'USERNAME'});
commands::runCommand("look");
