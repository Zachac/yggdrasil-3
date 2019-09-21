#!/usr/bin/perl

use strict;
use warnings;

use lib::model::room;
use lib::model::entities::entity;

my @ents = entity::getAll("i:$ENV{'USERNAME'}");

if (@ents > 0) {
    print "  You have in your inventory:\n";
    print "    $_\n" for @ents;
} else {
    print " Your inventory is empty\n";
}
