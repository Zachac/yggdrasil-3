#!/usr/bin/perl

use strict;
use warnings;

use lib::model::user::skills;
use lib::model::user::user;
use lib::model::entities::player;
use lib::model::combat::actions;

skills::requireLevel "punch", 1;

my $command = shift;
my $damage = int(rand(6)) + 1;
my $location = player::getLocation($ENV{'USERNAME'});
my $target = "@ARGV" if @ARGV;

die "usage: $command [target]\n" unless defined $target;

combat::actions::attackEntityByNameAndLocationAndAmountAndAttackerName($target, $location, $damage);

1;