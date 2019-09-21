#!/usr/bin/perl
package item;

use strict;
use warnings;

use lib::model::entities::entity;


sub getLocation($) {
    my $name = shift;
    return entity::getLocation('item', $name);
}

sub getAll($) {
    my $location = shift;
    return entity::getAllOf($location, 'item');
}

sub setLocation($$$) {
    my $location = shift;
    my $name = shift;
    my $id = shift;
    return entity::setLocation($location, 'item', $name, $id);
}

sub find($$) {
    my $name = shift;
    my $location = shift;
    return entity::typeExistsIn($name, $location, 'item');
}

1;