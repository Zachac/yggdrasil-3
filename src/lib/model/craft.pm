#!/usr/bin/perl
package craft;

use strict;
use warnings;

use environment::db qw(conn);
use lib::model::inventory;
use lib::model::skills;

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

sub getLevel($) {
    my $item_name = shift;
    return $db::conn->selectrow_array('select skill_name, required_level from recipe where item_name = ?', undef, $item_name);
}

sub getExp($) {
    my $item_name = shift;
    return $db::conn->selectrow_array('select skill_name, experience from recipe where item_name = ?', undef, $item_name);
}

sub craft($$) {
    my $username = shift;
    my $item_name = shift;

    die "recipe for $item_name does not exist\n" unless craft::exists($item_name);
    skills::requireLevel(getLevel($item_name), $username);

    my @required_items = @{$db::conn->selectall_arrayref('select required_name, count from recipe_requirements where item_name = ? order by required_name asc', undef, $item_name)};

    if (@required_items <= 0) {
        return defined inventory::add($username, $item_name);
    }

    my @inv = sort {@$a[0] cmp @$b[0]} inventory::getAllNamesAndCounts($username);

    my $j = 0;
    for my $item (@required_items) {
        for (my $i = 0; $i < @$item[1]; $i++) {
            $j++ while ($j < @inv && $inv[$j][0] ne @$item[0]);
            
            unless ($j < @inv) {
                die "missing (@$item[0]) required: @{[map {\"\n  $_\"} recipe($item_name, @required_items)]}\n";
            }
            
            if ($inv[$j][1] >= @$item[1]) {
                $j++;
                last;
            } elsif ($j + 1 < @inv) {
                $inv[$j + 1][1] += $inv[$j][1];
                $i += $inv[$j][1];
                $inv[$j][1] = 0;
                redo;
            }
        }
    }

    my $swapLocation = "p:d:$$";
    my @items = ();
    # for my $item (@required_items) {
    #     for (1 .. @$item[1]) {
    #         my $success = inventory::drop($username, @$item[0], $swapLocation);

    #         unless ($success) {
    #             inventory::take($username, @$_[0], $swapLocation) for @items;
    #             die "Recipe component removed from inventory during crafting!\n";
    #         } else {
    #             unshift @items, @$item[0];
    #         }
    #     }
    # }

    # inventory::add($username, $item_name);
    # item::deleteAll($swapLocation);
    # skills::addExp($username, getExp($item_name));
}



1;