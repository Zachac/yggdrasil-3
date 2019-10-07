#!/usr/bin/perl
package item;

use strict;
use warnings;

use lib::model::entities::entity;

sub getAll($) {
    my $location = shift;
    return entity::getAllOfIn('item', $location);
}

sub setLocation($$$) {
    my $location = shift;
    my $name = shift;
    my $id = shift;
    return entity::setLocation($name, $location, 'item', $id);
}

sub find($$) {
    my $name = shift;
    my $location = shift;
    return entity::typeExistsIn($name, $location, 'item');
}

sub create($$) {
    my $name = shift;
    my $location = shift;
    return entity::create($name, $location, 'item');
}

sub deleteAll($) {
    my $location = shift;
    return entity::deleteAll($location, 'item');
}

sub delete($) {
    my $id = shift;
    return entity::delete('item', $id);
}

1;