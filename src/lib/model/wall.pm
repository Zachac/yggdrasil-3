#!/usr/bin/perl
package wall;

use strict;
use warnings;


sub getAll($) {
    my $location = shift;
    return @{db::selectcol_arrayref('select name from wall where location=?', undef, $location)};
}

sub find($$) {
    my $name = shift;
    my $location = shift;
    return db::selectrow_array('select 1 from wall where location=? and name=?', undef, $location, $name);
}

sub create($$) {
    my $name = shift;
    my $location = shift;
    return db::selectrow_array('insert or ignore into wall(location, name) values(?,?)', undef, $location, $name);
}

1;