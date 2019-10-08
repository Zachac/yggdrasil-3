#!/usr/bin/perl

use strict;
use warnings;

use lib::model::room;
use lib::model::links;
use lib::model::entities::entity;
use lib::model::entities::player;

use lib::io::format;

commands::runCommand("map", 2);

my $room = player::getLocation($ENV{'USERNAME'});
print room::name($room), "\n";
print room::description($room), "\n";

my @exits = links::getExits($room);
@exits = ("none") unless (@exits > 0);
print "  Obvious exits: @exits\n";

my $ents = entity::getAllEx($room);

if (@$ents > 0) {
    print "  You can see:\n";
    for (@$ents) {
        if (player::isPlayer(@$_[1])) {
            print "    @$_[0]\n" 
        } else {
            my $item = format::withArticle(@$_[0]);
            print "    $item\n" 
        }
    }
}
