#!/usr/bin/perl

use strict;
use warnings;

use lib::model::user::skills;
use lib::model::user::user;
use lib::model::entities::player;
use lib::model::combat::actions;

my $command = shift;
my $level = skills::requireLevel $command, 1;
my $target = @ARGV ? "@ARGV" : $ENV{'TARGET'};

my $damage = 0;
$damage += int(rand(6)) + 1 for (1 .. $level);

die "usage: $command [target]\n" unless defined $target;

combat::actions::damage($target, player::getLocation($ENV{'USERNAME'}), $damage);

1;