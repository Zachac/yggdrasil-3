#!/usr/bin/perl

use strict;
use warnings;

use lib::model::room;
use lib::model::user;

my $room = user::getLocation($ENV{'USERNAME'});
print room::description($room), "\n";

my @players = user::getUsersNearby($ENV{'USERNAME'});
print "There is: @players\n";

my @exits = room::getExits($room);
if (scalar(@exits) > 0) {
    print "Obvious exits: @exits\n";
} else {
    print "Obvious exits: none\n";
}
