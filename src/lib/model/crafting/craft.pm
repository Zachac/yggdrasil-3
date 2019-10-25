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

    my @inv = sort {@$a[0] cmp @$b[0]} inventory::getAllNamesAndCounts($username);

    my $j = 0;
    for my $item (@required_items) {
        for (my $i = 0; $i < @$item[1]; $i++) {
            $j++ while ($j < @inv && ($inv[$j][0] ne @$item[0] || $inv[$j][1] <= 0));
            
            unless ($j < @inv) {
                die "missing (@$item[0]) required: @{[map {\"\n  $_\"} recipe::requirements($item_name, @required_items)]}\n";
            }

            my $required_count = @$item[1] - $i;
            if ($inv[$j][1] >= $required_count) {
                $i += $required_count;
                $inv[$j][1] -= $required_count;
            } elsif ($j + 1 < @inv) {
                $inv[$j + 1][1] += $inv[$j][1];
                $i += $inv[$j][1] - 1;
                $inv[$j][1] = 0;
            }
        }
    }

    my $swapLocation = "p:d:$$";
    my @items = ();
    for my $item (@required_items) {
        my $dropped_count = inventory::drop($username, @$item[0], $swapLocation, @$item[1]);
        
        push @items, @$item[0];

        unless ($dropped_count == @$item[1]) {
            inventory::take($username, $_, $swapLocation, "inf") for @items;
            die "Recipe component removed from inventory during crafting!\n";
        }
    }

    inventory::add($username, $item_name);
    item::deleteByLocation($swapLocation);
    skills::addExp($username, recipe::getExpByItemName($item_name));
}

1;