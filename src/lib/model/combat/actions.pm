#!/usr/bin/perl
package combat::actions;

use strict;
use warnings;

use lib::model::entities::entity;


sub attackEntityByNameAndLocationAndAmount($$$) {
    my $name = shift;
    my $location = shift;
    my $damage = shift;
    my $entity_id = entity::getIdByNameAndLocation($name, $location);

    die "Cannot attack, unable to find $name\n" unless defined $entity_id;

    my $killed = entity::addHealthById(-$damage, $entity_id);

    die "Cannot harm immortal object\n" unless defined $killed;

    if ($killed) {
        processDeathById($entity_id);
    }

    return $killed;
}

sub processDeathById($) {
    my $entity_id = shift;


}

1;