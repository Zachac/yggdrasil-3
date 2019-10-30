#!/usr/bin/perl
package combat::actions;

use strict;
use warnings;

use lib::model::entities::entity;
use lib::model::user::inventory;


sub attackEntityByNameAndLocationAndAmount($$$) {
    my $name = shift;
    my $location = shift;
    my $damage = shift;
    my $entity_id = entity::getIdByNameAndLocation($name, $location);

    die "Cannot attack, unable to find $name\n" unless defined $entity_id;

    my $killed = entity::addHealthById(-$damage, $entity_id);

    die "Cannot harm immortal object\n" unless defined $killed;

    if ($killed) {
        processDeathByIdAndNameAndLocation($entity_id, $name, $location);
    }

    return $killed;
}

sub processDeathByIdAndNameAndLocation($$$) {
    my $entity_id = shift;
    my $name = shift;
    my $location = shift;

    if (player::getIsPlayerByName($name)) {
        commands::runAs($name, "look");
        user::echo "You died!\n";
        inventory::dump($name, $location);
    }
}

1;