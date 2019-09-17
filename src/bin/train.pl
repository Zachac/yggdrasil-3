#!/usr/bin/perl

use strict;
use warnings;

use lib::model::skills;

print "\n";

unless (@ARGV == 2) {
    print "usage: $ARGV[0] skill\n";
    return 0;
}

my $skill = lc $ARGV[1];

if (defined eval {skills::train($skill)}) {
    print "Level up!\n";
} else {
    print "Could not level up: $@";
}


