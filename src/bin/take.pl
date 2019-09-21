#!/usr/bin/perl

use strict;
use warnings;

use lib::model::item;
use lib::model::player;

my $command = shift;

unless (@ARGV > 0) {
    print "usage: $command take item name\n";
    return 1;
}

my $item_name = "@ARGV";

my $location = player::getLocation($ENV{'USERNAME'});
my $otherLoc = item::getLocation($item_name);


if (defined $otherLoc && $otherLoc eq $location) {
    item::setLocation($item_name, "i:$ENV{'USERNAME'}");
    print "You take it and put it in your inventory\n";
} else {
    print "You can't seem to find the '$item_name'\n";
}
