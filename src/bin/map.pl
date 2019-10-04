#!/usr/bin/perl

use strict;
use warnings;

use lib::model::map;
use lib::model::entities::player;

my $command = shift;

my $location = player::getLocation($ENV{'USERNAME'});
my ($x, $y) = map::getCoordinates($location);

print map::get($x, $y, shift);
