#!/usr/bin/perl

use strict;
use warnings;

use lib::model::user::skills;
use lib::model::user::user;
use lib::model::entities::player;
use lib::model::combat::actions;

skills::requireLevel "punch", 1;

my $command = shift;
my $target;
my $damage = int(rand(6)) + 1;
my $location = player::getLocation($ENV{'USERNAME'});

if (@ARGV > 0) {
    $target = "@ARGV";
} else {
    $target = $ENV{'TARGET'};
}

die "usage: punch [target]\n" unless defined $target;

my $killed_entity = combat::actions::attackEntityByNameAndLocationAndAmount($target, $location, $damage);
$ENV{'TARGET'} = $target;
user::echo "You hit the $target for $damage points of damage\n";

if ($killed_entity) {
    $ENV{'TARGET'} = undef;
} else {
    $ENV{'TARGET'} = $target;
}

1;