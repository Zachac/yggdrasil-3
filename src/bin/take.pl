#!/usr/bin/perl

use strict;
use warnings;

use lib::model::inventory;

my $command = shift;

unless (@ARGV > 0) {
    print "usage: $command take item name\n";
    return 1;
}

my $item_name = "@ARGV";
my $success = inventory::take($ENV{'USERNAME'}, "$item_name");


if (defined $success) {
    user::broadcastOthers($ENV{'USERNAME'}, "$ENV{'USERNAME'} takes $item_name");
    print "You take $item_name and put it in your inventory\n";
} else {
    print "You can't seem to find '$item_name'\n";
}
