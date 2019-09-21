#!/usr/bin/perl

use strict;
use warnings;

use lib::model::entity;

my $command = shift;

unless (@ARGV > 0) {
    print "usage: $command take item name\n";
    return 1;
}

my $item_name = "@ARGV";

my $location = entity::getLocation('player', $ENV{'USERNAME'});
my $otherLoc = entity::getLocation('item', $item_name);


if (defined $otherLoc && $otherLoc eq $location) {
    entity::setLocation("i:$ENV{'USERNAME'}", 'item', $item_name);
    print "You take it and put it in your inventory\n";
} else {
    print "You can't seem to find the '$item_name'\n";
}
