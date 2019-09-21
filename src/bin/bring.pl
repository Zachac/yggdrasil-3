#!/usr/bin/perl

use strict;
use warnings;

use lib::model::entity;

my $command = shift;

unless (@ARGV > 0) {
    print "usage: $command item name\n";
    return 1;
}

my $item_name = "@ARGV";

my $location = entity::getLocation('player', $ENV{'USERNAME'});
my $otherLoc = entity::getLocation('item', $item_name);
entity::setLocation($location, 'item', $item_name);
print "$otherLoc -- $location\n";
if (defined $otherLoc && $otherLoc eq $location) {
    print "it's already here\n";
} else {
    print "It materializes into the room\n";
}
