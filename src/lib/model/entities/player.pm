#!/usr/bin/perl
package player;

use strict;
use warnings;

use lib::model::entities::entity;
use lib::model::entities::entity_type;
use lib::model::entities::entity_def;

my $type = entity_type::register('player');


sub getLocation($) {
    my $name = shift;
    return entity::getLocationByTypeAndName('player', $name);
}

sub getAll($) {
    my $location = shift;
    return entity::getEntityNamesByTypeAndLocation('player', $location);
}

sub getIsPlayerByName($) {
    return $type == entity_def::getTypeIdByName shift;
}

sub setLocation($$) {
    my $name = shift;
    my $location = shift;
    return entity::setLocationByNameAndType($location, $name, 'player');
}

sub create($$) {
    my $name = shift;
    my $location = shift;
    entity_def::register($name, 'player', undef, 100);
    return entity::createByNameAndTypeAndLocation($name, 'player', $location);
}

sub isPlayer($) {
    return shift eq 'player';
}

1;