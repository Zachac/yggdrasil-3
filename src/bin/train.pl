#!/usr/bin/perl

use strict;
use warnings;

use lib::model::skills;

my $command = shift;

die "usage: $command skill\n" unless (@ARGV >= 1);

my $skill = "@ARGV";
my $newLevel = skills::train(lc $skill);
if ($newLevel != 1) {
    print "Level up, $skill level $newLevel!\n";
} else {
    print "You begin to pay closer attention when you $skill\n";
}


