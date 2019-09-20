#!/usr/bin/perl

use strict;
use warnings;

require lib::model::room;
require lib::model::links;
require lib::model::entity;

if (@ARGV < 2) {
    print "ERROR: usage: link destination name\n";
    return 0;
}

my $location = entity::getLocation('player', $ENV{'USERNAME'});

if (links::add($location, $ARGV[0], $ARGV[1])) {
    print "Linked!\n";
} else {
    print "Could not create link: $!\n";
}
