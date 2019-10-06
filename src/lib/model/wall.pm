#!/usr/bin/perl
package wall;

use strict;
use warnings;

$db::conn->do("CREATE TABLE IF NOT EXISTS wall (
    location NOT NULL,
    name NOT NULL,
    UNIQUE(location, name)
);");

sub getAll($) {
    my $location = shift;
    return @{$db::conn->selectcol_arrayref('select name from wall where location=?', undef, $location)};
}

sub find($$) {
    my $name = shift;
    my $location = shift;
    return $db::conn->selectrow_array('select 1 from wall where location=? and name=?', undef, $location, $name);
}

sub create($$) {
    my $name = shift;
    my $location = shift;
    return $db::conn->selectrow_array('insert or ignore into wall(location, name) values(?,?)', undef, $location, $name);
}

1;