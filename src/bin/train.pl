#!/usr/bin/perl

use strict;
use warnings;

use lib::model::user::skills;
use lib::model::user::user;

my $command = shift;

die "usage: $command skill\n" unless (@ARGV >= 1);

my $skill = "@ARGV";
my $newLevel = skills::train($ENV{'USERNAME'}, lc $skill);
if ($newLevel != 1) {
    user::echo "Level up, $skill level $newLevel!\n";
} else {
    user::echo "You begin to pay closer attention when you $skill\n";
}


