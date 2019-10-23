#!/usr/bin/perl
package entity_type;

use strict;
use warnings;

use lib::env::db;

sub register($) {
    my $type = shift;
    db::do('insert ignore into entity_type(entity_type) values (?)', undef, $type);
    return db::selectrow_array('select entity_type_id from entity_type where entity_type = ?', undef, $type);
}

1;