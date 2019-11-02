#!/usr/bin/perl

use strict;
use warnings;

use lib::env::env;
use lib::model::crafting::craft;
use lib::model::user::user;

my $command = shift;

die "usage: $command item name\n" if (@ARGV <= 0);

my $item_name = "@ARGV";

if (craft::craft($ENV{'USERNAME'}, $item_name)) {
    user::broadcastAction($ENV{'USERNAME'}, "created a $item_name");
} else {
    user::echo "Could not create $item_name\n";
}
