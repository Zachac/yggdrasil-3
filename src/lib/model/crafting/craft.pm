#!/usr/bin/perl
package craft;

use strict;
use warnings;

use lib::env::db qw(conn);
use lib::model::user::inventory;
use lib::model::user::skills;
use lib::model::crafting::recipe;



sub craft($$) {
    my $username = shift;
    my $item_name = shift;

    die "recipe for $item_name does not exist\n" unless recipe::exists($item_name);
    skills::requireLevel(recipe::getLevelByItemName($item_name), $username);

    my @required_items = @{db::selectall_arrayref('select required_name, count from recipe_requirements where item_name = ? order by required_name asc', undef, $item_name)};

    if (@required_items <= 0) {
        return defined inventory::add($username, $item_name);
    }

    my $swapLocation = "p:d:$$";
    my @inv = sort {@$a[0] cmp @$b[0]} inventory::getAllNamesAndCounts($username);
    my @items = ();
    for my $req_item (@required_items) {
        my $req_item_name = @$req_item[0];
        my $req_item_count = @$req_item[1];

        my $dropped_count = inventory::drop($username, $req_item_name, $swapLocation, $req_item_count);
        
        push @items, $req_item_name;
        
        unless ($dropped_count == $req_item_count) {
            inventory::take($username, $_, $swapLocation, "inf") for @items;
            die "missing ($req_item_name) required: @{[map {\"\n  $_\"} recipe::requirements($item_name, @required_items)]}\n";
        }
    }

    inventory::add($username, $item_name);
    item::deleteByLocation($swapLocation);
    skills::addExp($username, recipe::getExpByItemName($item_name));
}

1;