#!/usr/bin/perl
package inventory;

use strict;
use warnings;

use lib::model::entities::entity;
use lib::model::entities::item;
use lib::model::entities::player;

sub getAllNamesAndCounts($) {
    my $username = shift;
    return item::getNamesAndCountsByLocation("i:$username");
}

sub take($$;$$) {
    my $username = shift;
    my $item_name = shift;
    my $location = shift // player::getLocation($username);
    my $count = shift // 1;

    if ($count == 1) {
        return item::setLocationByNameAndLocation("i:$username", $item_name, $location) ? 1 : 0;
    } elsif (item::isStackable $item_name) {
        return item::splitByNameAndLocationAndCountToLocation($item_name, $location, $count, "i:$username") ? $count : 0;
    } else {
        my $result = 0;
        for (my $i = 0; $i < $count && $result; $i++) {
            $result = item::setLocationByNameAndLocation("i:$username", $item_name, $location);
            $result++;
        }
        return $result;
    }
}

sub drop($$;$$) {
    my $username = shift;
    my $item_name = shift;
    my $location = shift // player::getLocation($username);
    my $count = shift;

    if (! defined $count) {
        return item::setLocationByNameAndLocation($location, $item_name, "i:$username") ? 1 : 0;
    } elsif (item::isStackable $item_name) {
        return item::splitByNameAndLocationAndCountToLocation($item_name, "i:$username", $count, $location) ? $count : 0;
    } else {
        my $result = 0;
        for (my $i = 0; $i < $count && $result; $i++) {
            return $result unless item::setLocationByNameAndLocation($location, $item_name, "i:$username");
            $result++;
        }
        return $result;
    }
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