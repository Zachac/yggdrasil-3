#!/usr/bin/perl

use strict;
use warnings;

use lib::model::inventory;
use lib::io::format;

my @ents = inventory::getAll($ENV{'USERNAME'});

if (@ents > 0) {
    print "  You have in your inventory:\n";
    print "    ", format::withArticle($_), "\n" for @ents;
} else {
    print " Your inventory is empty\n";
}
