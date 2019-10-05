#!/usr/bin/perl

use strict;
use warnings;

use lib::model::room;
use lib::model::links;
use lib::model::entities::entity;
use lib::model::entities::player;

my $room = player::getLocation($ENV{'USERNAME'});
print room::name($room), "\n";
print room::description($room), "\n";

my @exits = links::getExits($room);
@exits = ("none") unless (@exits > 0);
print "  Obvious exits: @exits\n";

my @ents = entity::getAll($room);

if (@ents > 0) {
    commands::runCommand("map", 2);
    print "  You can see:\n";
    print "    $_\n" for @ents;
}
