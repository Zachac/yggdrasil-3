#!/usr/bin/perl
package entity_def;

use strict;
use warnings;

use lib::env::db;

sub safeEq($$) {
    my $v1 = shift;
    my $v2 = shift;
    return ! defined $v2 unless defined $v1;
    return 0 unless defined $v2;
    return $v1 eq $v2;
}

sub register($$$) {
    my $name = shift;
    my $type = shift;
    my $description = shift;

    my (
        $existing_type,
        $existing_description, 
    ) = db::selectrow_array('select entity_type, description from entity_def def join entity_type typ on typ.entity_type_id = def.entity_type_id where def.entity_name = ?', undef, $name);

    if (defined $existing_type // $existing_description) {
        # if a definition already exists, confirm that
        # the two definitions are equal
        die "Different definition already exists for $name:$type:$description" 
        unless safeEq($type, $existing_type) 
            && safeEq($description, $existing_description)
    } else {
        db::do('insert into entity_def(entity_name, entity_type_id, description) values (?, (select entity_type_id from entity_type where entity_type = ?), ?)', undef, $name, $type, $description);
    }

    return db::selectrow_array('select entity_def_id from entity_def where entity_name = ?', undef, $type);
}

1;