#!/usr/bin/perl

use strict;
use warnings;

use lib::model::entity;
use lib::model::player;

shift(@ARGV);

my $name = "@ARGV";
my $location = player::getLocation($ENV{'USERNAME'});
my ($entity_type, $entity_id)= entity::existsIn($name, $location);

if (defined $entity_type && defined $entity_id) {
    print entity::description($name, $entity_type, $entity_id), "\n";
    return;
} else {
    print "You can't seem to find the '$name'\n";
}
