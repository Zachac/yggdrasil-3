#!/usr/bin/perl

use strict;
use warnings;

require lib::model::room;

if (room::exists(".")) {
    print room::description("."), "\n";

    my @players = room::getUsers(".");

    print "There is: @players\n";

    my @exits = room::getExits(".");

    if (scalar(@exits) > 0) {
        print "Obvious exits: @exits\n";
    } else {
        print "Obvious exits: none\n";
    }

} else {
    print "You don't see anything in particular.\n";
}
