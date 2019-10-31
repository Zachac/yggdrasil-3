#!/usr/bin/perl
package entity_drop;

use strict;
use warnings;

use lib::env::db;

sub register($$$$;$) {
    my $entity_name = shift;
    my $item_name = shift;
    my $chance = shift;
    my $min_count = shift;
    my $max_count = shift // $min_count;

    return 0 != db::do('
    insert into entity_drop(entity_def_id, item_def_id, min_count, max_count, chance)
    values (
        (select entity_def_id from entity_def where entity_name=?),
        (select entity_def_id from entity_def where entity_name=?),
        ?, ?, ?)', undef, $entity_name, $item_name, $min_count, $max_count, $chance);
}

sub getItemNameAndCountsByEntityName($) {
    my $entity_name = shift;
    my $drops = db::selectall_arrayref('select entity_name, chance, min_count, max_count from entity_drop join entity_def def on def.entity_def_id = item_def_id where entity_drop.entity_def_id = (select entity_def_id from entity_def where entity_name = ?)', undef, $entity_name);
    my $count = scalar(@$drops);
    my @results = ();

    for my $drop (@$drops) {
        if (@$drop[1] > rand) {
            my $count = @$drop[2] + 1 + int(rand(@$drop[3] - @$drop[2]));
            push @results, [@$drop[0], $count];
        }
    }

    return @results;
}



1;