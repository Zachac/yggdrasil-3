#!/usr/bin/perl

use strict;
use warnings;

use lib::model::inventory;

my @ents = inventory::getAll($ENV{'USERNAME'});

if (@ents > 0) {
    print "  You have in your inventory:\n";
    print "    $_\n" for @ents;
} else {
    print " Your inventory is empty\n";
}
