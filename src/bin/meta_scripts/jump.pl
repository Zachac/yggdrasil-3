#!/usr/bin/perl

use strict;
use warnings;

use lib::model::entities::player;
use lib::model::commands::commands;
use lib::model::user::user;
use lib::model::map::map;


my $command = shift;

unless (@ARGV > 0) {
    user::echo "usage: $command location\n";
    return 1;
}

my $location = "@ARGV";

user::broadcastOthers($ENV{'USERNAME'}, "$ENV{'USERNAME'} leaves");
if (player::setLocation($ENV{'USERNAME'}, $location)) {
    map::init($location);
    user::broadcastOthers($ENV{'USERNAME'}, "$ENV{'USERNAME'} enters");
    commands::runCommand("look");
} else {
    user::echo "Unable to jump to @ARGV\n";
}

return 1;