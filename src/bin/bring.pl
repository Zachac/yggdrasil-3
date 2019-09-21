#!/usr/bin/perl

use strict;
use warnings;

use lib::model::entity;

my $command = shift;

unless (@ARGV > 0) {
    print "usage: $command entity name\n";
    return 1;
}

my $item_name = "@ARGV";

my $location = entity::getLocation('player', $ENV{'USERNAME'});
my $otherLoc = entity::getLocation(undef, $ENV{'USERNAME'});
entity::setLocation($location, undef, $item_name);

if (defined $otherLoc && $otherLoc == $location) {
    print "it's already here\n";
} else {
    print "It materializes into the room\n";
}
