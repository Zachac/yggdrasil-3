#!/usr/bin/perl
package player;

use strict;
use warnings;

use lib::model::entities::entity;


sub getLocation($) {
    my $name = shift;
    return entity::getLocation('player', $name);
}

sub getAll($) {
    my $location = shift;
    return entity::getAllOfIn('player', $location);
}

sub setLocation($$) {
    my $name = shift;
    my $location = shift;
    return entity::setLocation($name, $location, 'player');
}

1;