#!/usr/bin/perl

use strict;
use warnings;

require lib::model::room;
require lib::model::links;
require lib::model::entity;
use lib::model::player;

if (@ARGV < 2) {
    print "ERROR: usage: link destination name\n";
    return 0;
}

my $location = player::getLocation($ENV{'USERNAME'});

if (links::add($location, $ARGV[0], $ARGV[1])) {
    print "Linked!\n";
} else {
    print "Could not create link: $!\n";
}
