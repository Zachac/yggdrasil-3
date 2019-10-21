#!/usr/bin/perl

use strict;
use warnings;

use lib::env::env;
use lib::model::commands::logic::craft;
use lib::model::user::user;

my $command = shift;

die "usage: $command item name\n" if (@ARGV <= 0);

my $item_name = "@ARGV";

if (craft::craft($ENV{'USERNAME'}, $item_name)) {
    user::broadcastOthers($ENV{'USERNAME'}, "$ENV{'USERNAME'} creates $item_name");
    print "You create $item_name\n";
} else {
    print "Could not create $item_name\n";
}
