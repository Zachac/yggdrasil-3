#!/usr/bin/perl

use strict;
use warnings;

use lib::model::entities::entity;
use lib::model::entities::player;

my $name = $ENV{'USERNAME'};
my $location = player::getLocation($name);

my @health_info = entity::getHealthAndMaxHealthByNameAndLocation($name, $location);

user::echo "Health: $health_info[0][0]/$health_info[0][1]\n";

1;