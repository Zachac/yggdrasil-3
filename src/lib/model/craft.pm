#!/usr/bin/perl
package craft;

use strict;
use warnings;

use environment::db qw(conn);
use lib::model::inventory;

$db::conn->do("CREATE TABLE IF NOT EXISTS recipe_requirements (
    item_name NOT NULL,
    required_name NOT NULL,
    UNIQUE(item_name, required_name)
);");

$db::conn->do("CREATE TABLE IF NOT EXISTS recipe (
    item_name NOT NULL PRIMARY KEY,
    skill_name,
    required_level NOT NULL DEFAULT 0,
    experience NOT NULL DEFAULT 0
);");


sub exists($) {
    my $item_name = shift;
    return 0 != $db::conn->selectrow_array('select count(1) from recipe where item_name = ?', undef, $item_name);
}

sub craft($$) {
    my $username = shift;
    my $item_name = shift;

    die "recipe for $item_name does not exist\n" unless craft::exists($item_name);

    my @required_items = sort @{$db::conn->selectcol_arrayref('select required_name from recipe_requirements where item_name = ?', undef, $item_name)};

    if (@required_items <= 0) {
        inventory::add($username, $item_name);
        return 1;
    }

    my @inv = sort(inventory::getAll($username));

    my $i = 0;
    my $j = 0;
    while ($i < @required_items && $j < @inv) {
        if ($inv[$j] eq $required_items[$i]) {
            $i++;
            $j++;
        } else {
            $j++;
        }
    }

    if ($i < @required_items) {
        return 0;
    }

    my $swapLocation = "p:d:$$";
    my @items = ();
    for (@required_items) {
        my $item = inventory::drop($username, $_, $swapLocation);

        unless ($item) {
            inventory::take($username, $_, $swapLocation) for @items;
            return 0;
        }
    }

    inventory::add($username, $item_name);
    item::deleteAll($swapLocation);
}

1;