#!/usr/bin/perl

use strict;
use warnings;

use lib::model::entity;
use lib::model::player;

my $command = shift;

unless (@ARGV > 0) {
    print "usage: $command item name\n";
    return 1;
}

my $item_name = "@ARGV";

my $location = player::getLocation($ENV{'USERNAME'});
my ($item_type, $item_id) = entity::existsIn($item_name, "i:$ENV{'USERNAME'}");

if (defined $item_type && defined $item_id) {
    entity::setLocation($location, $item_type, $item_name, $item_id);
    print "You drop $item_name\n";
} else {
    print "You can't seem to find the '$item_name' in your inventory\n";
}
