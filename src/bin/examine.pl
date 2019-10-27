#!/usr/bin/perl

use strict;
use warnings;

use lib::model::entities::entity;
use lib::model::entities::entity_def;
use lib::model::entities::player;
use lib::model::user::user;

shift(@ARGV);

my $name = "@ARGV";
my $location = player::getLocation($ENV{'USERNAME'});
my $entity_id = entity::getIdByNameAndLocation($name, $location);

if (defined $entity_id) {
    user::echo entity_def::getDescriptionByName($name), "\n";
    return;
} else {
    user::echo "You can't seem to find the '$name'\n";
}
