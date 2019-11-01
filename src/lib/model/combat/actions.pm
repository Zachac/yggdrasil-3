#!/usr/bin/perl
package combat::actions;

use strict;
use warnings;

use lib::model::entities::entity;
use lib::model::entities::entity_drop;
use lib::model::entities::item;
use lib::model::user::inventory;
use lib::model::user::user;


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
    my @death_message = ();

    if (player::getIsPlayerByName($name)) {
        commands::runAs($name, "look");
        user::echo "You died!\n";
        inventory::dump($name, $location);
    } else {
        push @death_message, "The ";
    }

    push @death_message, $name, " dies";
    for my $drop (entity_drop::getItemNameAndCountsByEntityName($name)) {
        item::create(@$drop[0], $location, @$drop[1]);
        push @death_message, "\n  Drops ", @$drop[0], " ", "x", @$drop[1];
    }

    push @death_message, "\n";
    user::broadcast(undef, join('', @death_message), $location);
}

1;