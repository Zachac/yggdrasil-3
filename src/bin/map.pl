#!/usr/bin/perl

use strict;
use warnings;

use lib::model::map::map;
use lib::model::entities::player;
use lib::model::user::user;

my $command = shift;

my $location = player::getLocation($ENV{'USERNAME'});
my ($x, $y) = map::getCoordinates($location, 1);
user::echo map::get($x, $y, shift) if defined $x;
