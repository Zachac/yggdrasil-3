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
    return db::do('insert into biome(biome_name, biome_symbol, enterable) values(?,?,?)', undef, @_);
}

sub registerSpawn($$$$) {
    my $biome_name = shift;
    my $entity_name = shift;
    my $entity_type = shift;
    my $chance = shift;
    return 0 != db::do('insert ignore into biome_spawns(biome_name, entity_name, entity_type, chance) values(?,?,?,?)', undef, $biome_name,  $entity_name, $entity_type, $chance);
}

sub getSpawnsById($) {
    my $biome_name = getNameById shift;
    return @{db::selectall_arrayref("select entity_name, entity_type, chance from biome_spawns where biome_name = ? order by entity_name, entity_type, chance", undef, $biome_name)};
}

1;