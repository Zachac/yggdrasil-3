#!/usr/bin/perl
package biome;

use strict;
use warnings;

use lib::env::db;
use lib::model::map::map;

my @ascii_table = ();
my @name_table = ();
my @enterable_table = ();

sub getNameById($) {
    my $id = shift;
    return $name_table[$id] 
        // ($name_table[$id] = db::selectrow_array('select biome_name from biome where biome_id = ?', undef, $id));
}

sub getEnterableById($) {
    my $id = shift;
    return $enterable_table[$id] 
        // ($enterable_table[$id] = db::selectrow_array('select enterable from biome where biome_id = ?', undef, $id));
}

sub getAsciiById($) {
    my $id = shift;
    return $ascii_table[$id] 
        // ($ascii_table[$id] = db::selectrow_array('select biome_symbol from biome where biome_id = ?', undef, $id));
}

sub getIdByName($) {
    return db::selectrow_array('select biome_id from biome where biome_name = ?', undef, shift);
}

sub registerByNameAndSymbolAndEnterable($$$) {
    my $name = shift;
    my $symbol = shift;
    my $enterable = shift;
    my $created = 0 != db::do('insert ignore into biome(biome_name, biome_symbol, enterable) values(?,?,?)', undef, $name, $symbol, $enterable);

    if ($created) {
        return db::selectrow_array('select LAST_INSERT_ID()');
    } else {
        return getIdByName($name) // die;
    }
}

sub registerSpawn($$$) {
    my $biome_name = shift;
    my $entity_name = shift;
    my $chance = shift;
    return 0 != db::do('insert into biome_spawns(biome_id, entity_def_id, chance) values((select biome_id from biome where biome_name = ?), (select entity_def_id from entity_def where entity_name = ?), ?)', undef, $biome_name,  $entity_name, $chance);
}

sub getSpawnsEntityDefIdAndChanceByBiomeId($) {
    my $biome_id = shift;
    return @{db::selectall_arrayref("select entity_def_id, chance from biome_spawns where biome_id = ? order by entity_def_id, chance desc", undef, $biome_id)};
}

1;