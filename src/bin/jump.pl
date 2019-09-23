#!/usr/bin/perl

use strict;
use warnings;

use lib::model::entities::player;
use lib::model::commands;


my $command = shift;

unless (@ARGV > 0) {
    print "usage: $command location\n";
    return 1;
}

user::broadcastOthers($ENV{'USERNAME'}, "$ENV{'USERNAME'} leaves");
if (player::setLocation($ENV{'USERNAME'}, "@ARGV")) {
    user::broadcastOthers($ENV{'USERNAME'}, "$ENV{'USERNAME'} enters");
    commands::runCommand("look");
} else {
    print "Unable to jump to @ARGV\n";
}
