#!/usr/bin/perl

use strict;
use warnings;

use lib::model::room;
use lib::model::links;
use lib::model::user;

my $room = user::getLocation($ENV{'USERNAME'});
print "\n";
print room::name($room), "\n";
print room::description($room), "\n";

my @players = user::getUsersNearby($ENV{'USERNAME'});
print "  There is: @players\n";

my @exits = links::getExits($room);
@exits = ("none") unless (@exits > 0);
print "  Obvious exits: @exits\n";

