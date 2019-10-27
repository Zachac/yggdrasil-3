#!/usr/bin/perl

use strict;
use warnings;

use lib::model::user::skills;
use lib::model::user::user;

my $totalLevel = 0;

foreach my $skill (skills::getAll()) {
    $totalLevel += @$skill[1];
    user::echo "@$skill[0]: level @$skill[1] + @$skill[2]xp\n";
}

user::echo "Total level: ($totalLevel)\n";

