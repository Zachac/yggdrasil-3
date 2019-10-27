#!/usr/bin/perl

use strict;
use warnings;

use lib::model::user::inventory;
use lib::io::format;
use lib::model::user::user;

my @ents = inventory::getAllNamesAndCounts($ENV{'USERNAME'});
my @inv = ();

if (@ents > 0) {
    push @inv, "  You have in your inventory:\n";
    for (@ents) {
        push @inv, "    ", format::withArticle(@$_[0]);
        push @inv, " x@$_[1]" if defined @$_[1] && @$_[1] > 1;
        push @inv, "\n"
    };
} else {
    push @inv, " Your inventory is empty\n";
}

user::echo @inv;
