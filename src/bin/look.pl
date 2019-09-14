#!/usr/bin/perl

use strict;
use warnings;

use lib::model::room;
use lib::model::user;

my $room = user::getLocation($ENV{'USERNAME'});

if (room::exists($room)) {
    print room::description($room), "\n";

    my @players = user::getUsersNearby($ENV{'USERNAME'});

    print "There is: @players\n";

    my @exits = room::getExits($room);

    if (scalar(@exits) > 0) {
        print "Obvious exits: @exits\n";
    } else {
        print "Obvious exits: none\n";
    }

} else {
    print "You don't see anything in particular.\n";
}
