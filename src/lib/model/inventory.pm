#!/usr/bin/perl
package inventory;

use strict;
use warnings;

use lib::model::entities::entity;
use lib::model::entities::item;
use lib::model::entities::player;

sub getAll($) {
    my $username = shift;
    return entity::getAll("i:$username");
}

sub take($$;$) {
    my ($username, $item_name, $location) = @_;
    $location = player::getLocation($username) unless defined $location;
    my $item_id = item::find($item_name, $location);

    if (defined $item_id) {
        item::setLocation("i:$username", $item_name, $item_id);
    }

    return $item_id;
}

sub drop($$;$) {
    my ($username, $item_name, $location) = @_;
    $location = player::getLocation($username) unless defined $location;
    my $item_id = item::find($item_name, "i:$username");

    if (defined $item_id) {
        warn "unable to move $item_name\n" unless item::setLocation($location, $item_name, $item_id);
    }

    return $item_id;
}

sub add($$) {
    my $username = shift;
    my $item_name = shift;
    return item::create($item_name, "i:$username");
}



1;