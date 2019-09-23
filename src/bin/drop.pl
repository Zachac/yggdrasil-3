#!/usr/bin/perl

use strict;
use warnings;

use lib::model::inventory;

my $command = shift;

unless (@ARGV > 0) {
    print "usage: $command item name\n";
    return 1;
}

my $item_name = "@ARGV";
my $item_id = inventory::drop($ENV{'USERNAME'}, $item_name);

if (defined $item_id) {
    print "You drop $item_name\n";
} else {
    print "You can't seem to find '$item_name' in your inventory\n";
}
