#!/usr/bin/perl

use strict;
use warnings;

use lib::model::inventory;
use lib::io::format;

my @ents = inventory::getAllNamesAndCounts($ENV{'USERNAME'});
my @inv = ();

if (@ents > 0) {
    push @inv, "  You have in your inventory:\n";
    for (@ents) {
        push @inv, "    ", format::withArticle(@$_[0]);
        push @inv, " x@$_[1]" if (@$_[1] != 1);
        push @inv, "\n"
    };
} else {
    push @inv, " Your inventory is empty\n";
}

print @inv;
