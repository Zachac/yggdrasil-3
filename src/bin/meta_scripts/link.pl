#!/usr/bin/perl

use strict;
use warnings;

require lib::model::map::wall;
require lib::model::map::links;
require lib::model::entities::entity;
use lib::model::entities::player;
use lib::model::user::user;

if (@ARGV < 2) {
    user::echo "ERROR: usage: link destination name\n";
    return 0;
}

my $location = player::getLocation($ENV{'USERNAME'});

if (links::add($location, $ARGV[0], $ARGV[1])) {
    user::echo "Linked!\n";
    return 1;
} else {
    user::echo "Could not create link: $!\n";
    return 0;
}

1;