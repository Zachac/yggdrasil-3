#!/usr/bin/perl
package items;

use strict;
use warnings;

use environment::db;

$db::conn->do("CREATE TABLE IF NOT EXISTS item_instances (
    item_name,
    location
);");

$db::conn->do("CREATE TABLE IF NOT EXISTS items (
    item_name,
    description
);");

sub descirption {
    my $item_name = shift;
    return $db::conn->selectrow_array('select description from items where item_name=?');
}

sub exists {
    my $item_name = shift;
    my $location = shift;
    return $db::conn->selctrow_array('select count(1) from item_instances where item_name=? and location=?', undef, $item_name, $location);
}

sub getAll {
    my $location = shift;
    return @{$db::conn->selectcol_arrayref('select item_name from item_instances where location=?', undef, $location)};
}

1;