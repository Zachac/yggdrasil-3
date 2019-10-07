#!/usr/bin/perl

use strict;
use warnings;

require lib::model::room;
require lib::model::links;
require lib::model::entities::entity;
use lib::model::entities::player;

if (@ARGV < 2) {
    print "ERROR: usage: link destination name\n";
    return 0;
}

my $location = player::getLocation($ENV{'USERNAME'});

if (links::add($location, $ARGV[0], $ARGV[1])) {
    print "Linked!\n";
    return 1;
} else {
    print "Could not create link: $!\n";
    return 0;
}
