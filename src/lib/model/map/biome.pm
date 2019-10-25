#!/usr/bin/perl
package biome;

use strict;
use warnings;

use lib::env::db;
use lib::model::map::map;

my @ascii_table = (' ', '~', '#');
my @name_table = ('Ocean', 'Shore', 'Forest');
my @enterable_table = (0, 1, 1);


sub getNameById($) {
    return $name_table[shift];
}

sub getEnterableById($) {
    return $enterable_table[shift];
}

sub getAsciiById($) {
    return $ascii_table[shift];
}

sub getIdByName($) {
    my $name = shift;
    
    for (my $i = 0; $i <= $#name_table; $i++) {
        return $i if $name_table[$i] eq $name;
    }

    return undef;
}

sub registerSpawn($$$$) {
    my $biome_name = shift;
    my $entity_name = shift;
    my $entity_type = shift;
    my $chance = shift;
    return db::do('insert ignore into biome_spawns(biome_name, entity_name, entity_type, chance) values(?,?,?,?)', undef, $biome_name,  $entity_name, $entity_type, $chance);
}

sub getSpawnsById($) {
    my $biome_name = getNameById shift;
    return @{db::selectall_arrayref("select entity_name, entity_type, chance from biome_spawns where biome_name = ? order by entity_name, entity_type, chance", undef, $biome_name)};
}

1;