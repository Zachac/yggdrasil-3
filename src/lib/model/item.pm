#!/usr/bin/perl
package item;

use strict;
use warnings;

use lib::model::entity;


sub getLocation($) {
    my $name = shift;
    return entity::getLocation('item', $name);
}

sub getAll($) {
    my $location = shift;
    return entity::getAllOf($location, 'item');
}

sub setLocation($$) {
    my $name = shift;
    my $location = shift;
    return entity::setLocation($location, 'item', $name);
}

1;