#!/usr/bin/perl
package entity_def;

use strict;
use warnings;

use lib::env::db;

# utility method
sub safeEq($$);

sub getDescriptionByName($) {
    my $entity_name = shift;
    my $description = db::selectrow_array('select description from entity_def where entity_name=?', undef, $entity_name);
    return $description if defined $description;
    return 'You don\'t notice anything interesting.';
}

sub register($$$;$) {
    my $name = shift;
    my $type = shift;
    my $description = shift;
    my $max_health = shift;
    db::do('insert into entity_def(entity_name, entity_type_id, description, max_health) values (?, (select entity_type_id from entity_type where entity_type = ?), ?, ?)', undef, $name, $type, $description, $max_health);
    return db::selectrow_array('select LAST_INSERT_ID()');
}



sub safeEq($$) {
    my $v1 = shift;
    my $v2 = shift;
    return ! defined $v2 unless defined $v1;
    return 0 unless defined $v2;
    return $v1 eq $v2;
}

1;