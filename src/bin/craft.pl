#!/usr/bin/perl

use strict;
use warnings;

use lib::model::craft;
use lib::model::user;

my $command = shift;

unless (@ARGV > 0) {
    print "usage: $command item name\n";
    return 1;
}

my $item_name = "@ARGV";

if (craft::craft($ENV{'USERNAME'}, $item_name)) {
    user::broadcastOthers($ENV{'USERNAME'}, "$ENV{'USERNAME'} creates $item_name");
    print "You create $item_name\n";
} else {
    print "Could not create $item_name\n";
}
