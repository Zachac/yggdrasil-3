#!/usr/bin/perl

use strict;
use warnings;

use lib::model::entities::item;
use lib::model::entities::player;

my $command = shift;

unless (@ARGV > 0) {
    print "usage: $command item name\n";
    return 1;
}

my $item_name = "@ARGV";

my $location = player::getLocation($ENV{'USERNAME'});
my $item_id = item::find($item_name, "i:$ENV{'USERNAME'}");


if (defined $item_id) {
    item::setLocation($location, $item_name, $item_id);
    print "You drop $item_name\n";
} else {
    print "You can't seem to find the '$item_name' in your inventory\n";
}
