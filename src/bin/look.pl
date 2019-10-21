#!/usr/bin/perl

use strict;
use warnings;

use lib::model::map::room;
use lib::model::map::links;
use lib::model::entities::entity;
use lib::model::entities::player;

use lib::io::format;

commands::runCommand("map", 2);

my $room = player::getLocation($ENV{'USERNAME'});
my $room_name = room::name($room);
my $room_description = room::description($room);

my @exits = links::getExits($room);
@exits = ("none") unless (@exits > 0);

my $ents = entity::getAllEx($room) // [];
my @players = map {@$_[0]} grep { player::isPlayer(@$_[1]) } @$ents;
my @ents = map {@$_[0]} grep { ! player::isPlayer(@$_[1]) } @$ents;

my @look = (
"$room_name\n",
"$room_description\n",
"  Obvious exits: @exits\n",
"  There is: @players\n");

if (@ents > 0) {
    push @look, "  You can see:\n";
    push @look, "    ", format::withArticle($_), "\n" for (@ents);
}

print @look;
