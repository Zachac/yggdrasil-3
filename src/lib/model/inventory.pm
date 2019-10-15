#!/usr/bin/perl
package inventory;

use strict;
use warnings;

use lib::model::entities::entity;
use lib::model::entities::item;
use lib::model::entities::player;

sub getAllItemNames($) {
    my $username = shift;
    return item::getAll("i:$username");
}

sub getAllNamesAndCounts($) {
    my $username = shift;
    return item::getNamesAndCountsByLocation("i:$username");
}

sub take($$;$) {
    my $username = shift;
    my $item_name = shift;
    my $location = shift // player::getLocation($username);
    return item::setLocationByNameAndLocation("i:$username", $item_name, $location);
}

sub drop($$;$) {
    my $username = shift;
    my $item_name = shift;
    my $location = shift // player::getLocation($username);
    return item::setLocationByNameAndLocation($location, $item_name, "i:$username");
}

sub add($$) {
    my $username = shift;
    my $item_name = shift;
    return item::create($item_name, "i:$username");
}

sub find($$) {
    my $username = shift;
    my $item_name = shift;
    return item::find($item_name, "i:$username");
}



1;