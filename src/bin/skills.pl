#!/usr/bin/perl

use strict;
use warnings;

use lib::model::skills;

my $totalLevel = 0;

print "\n";

foreach my $skill (skills::getAll()) {
    $totalLevel += @$skill[1];
    print "@$skill[0]: level @$skill[1] + @$skill[2]xp\n";
}

print "Total level: ($totalLevel)\n";

