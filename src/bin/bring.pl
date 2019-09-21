#!/usr/bin/perl

use strict;
use warnings;

use lib::model::player;
use lib::model::item;

my $command = shift;

unless (@ARGV > 0) {
    print "usage: $command item name\n";
    return 1;
}

my $item_name = "@ARGV";

my $location = player::getLocation($ENV{'USERNAME'});
my $otherLoc = item::getLocation($item_name);
item::setLocation($item_name, $location);

if (defined $otherLoc && $otherLoc eq $location) {
    print "it's already here\n";
} else {
    print "It materializes into the room\n";
}
