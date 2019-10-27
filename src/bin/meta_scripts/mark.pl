#!/usr/bin/perl

use strict;
use warnings;

use lib::model::map::map;
use lib::model::entities::player;
use lib::model::user::user;

my $command = shift;
my $mark;

if (@ARGV > 0) {
    $mark = "@ARGV";
} else {
    $mark = '( )';
}

if (map::mark(player::getLocation($ENV{'USERNAME'}), $mark)) {
    user::echo "You carefully mark the map with $mark at your location.\n";
    return 1;
} else {
    user::echo "You were unable to mark the map at your location.\n";
    return 0;
}

1;