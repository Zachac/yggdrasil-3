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
    return 0 == $db::conn->selectrow_array('select count(1) from recipe where item_name = ?', undef, $item_name);
}

sub craft($$) {
    my $username = shift;
    my $item_name = shift;

    die "recipe does not exist" unless exists($item_name);

    my @required_items = @{$db::conn->selectcol_arrayref('select required_name from recipe where item_name = ?', undef, $item_name)};
    inventory::destroyAll()
}

1;