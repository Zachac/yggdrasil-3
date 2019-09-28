#!/usr/bin/perl
package craft;

use strict;
use warnings;

use environment::db qw(conn);
use lib::model::inventory;

$db::conn->do("CREATE TABLE IF NOT EXISTS recipe_requirements (
    item_name NOT NULL,
    required_name NOT NULL,
    count NOT NULL DEFAULT 0,
    PRIMARY KEY(item_name, required_name)
);");

$db::conn->do("CREATE TABLE IF NOT EXISTS recipe (
    item_name NOT NULL PRIMARY KEY,
    skill_name,
    required_level NOT NULL DEFAULT 0,
    experience NOT NULL DEFAULT 0
);");

$db::conn->do('insert or ignore into recipe(item_name, skill_name, required_level, experience) values("fire pit kit", "scavenging", 2, 10)');
$db::conn->do('insert or ignore into recipe_requirements(item_name, required_name, count) values("fire pit kit", "rocks", 3)');
$db::conn->do('insert or ignore into recipe_requirements(item_name, required_name, count) values("fire pit kit", "leaves", 2)');

sub exists($) {
    my $item_name = shift;
    return 0 != $db::conn->selectrow_array('select count(1) from recipe where item_name = ?', undef, $item_name);
}

sub recipe($;@) {
    my $item_name = shift;
    my @required_items = @_;
    
    unless (@required_items) {
        @required_items = @{$db::conn->selectall_arrayref('select required_name, count from recipe_requirements where item_name = ?', undef, $item_name)};
    }

    return map { "@$_[0] x@$_[1]" } @required_items;
}

sub craft($$) {
    my $username = shift;
    my $item_name = shift;

    die "recipe for $item_name does not exist\n" unless craft::exists($item_name);

    my @required_items = sort {@$a[0] cmp @$b[0]} @{$db::conn->selectall_arrayref('select required_name, count from recipe_requirements where item_name = ?', undef, $item_name)};

    if (@required_items <= 0) {
        inventory::add($username, $item_name);
        return 1;
    }

    my @inv = sort(inventory::getAll($username));

    my $i = 0;
    my $j = 0;
    while ($i < @required_items && $j < @inv) {
        if ($inv[$j] eq $required_items[$i][0]) {
            $i++;
            $j++;
        } else {
            $j++;
        }
    }

    if ($i < @required_items) {
        die "required items: @{[map {\"\n  $_\"} recipe($item_name, @required_items)]}\n";
    }

    my $swapLocation = "p:d:$$";
    my @items = ();
    for (@required_items) {
        my $item = inventory::drop($username, @$_[0], $swapLocation);

        unless ($item) {
            inventory::take($username, @$_[0], $swapLocation) for @items;
            die "Item removed from inventory during crafting!\n";
        }
    }

    inventory::add($username, $item_name);
    item::deleteAll($swapLocation);
}



1;