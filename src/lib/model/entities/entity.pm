#!/usr/bin/perl
package entity;

use strict;
use warnings;

use lib::env::db;


sub getIdByNameAndLocation($$) {
    return db::selectrow_array('select entity_id from entity where entity_name=? and location=?', undef, @_);
}

sub getIdByNameAndLocationAndType($$$) {
    return db::selectrow_array('select entity_id from entity where entity_name=? and location=? and entity_type = ?', undef, @_);
}

sub getNamesAndTypesAndIdsByLocation($) {
    return db::selectall_arrayref('select entity_name, entity_type, entity_id from entity where location=?', undef, @_);
}

sub getEntityNamesByTypeAndLocation($$) {
    return @{db::selectcol_arrayref('select entity_name from entity where entity_type=? and location=?', undef, @_)};
}

sub getNamesAndEntityIdsByTypeAndLocation($$) {
    return @{db::selectall_arrayref('select entity_name, entity_id from entity where entity_type=? and location=?', undef, @_)};
}

sub getEntityIdsByNameAndLocation($$) {
    return @{db::selectcol_arrayref('select entity_id from entity where entity_name=? and location=?', undef, @_)};
}

sub getLocationByTypeAndName {
    return db::selectrow_array('select location from entity where entity_type = ? and entity_name = ?', undef, @_);
}

sub getHealthAndMaxHealthByNameAndLocation($$) {
    return @{db::selectall_arrayref('select health, max_health from entity where entity_name=? and location=?', undef, @_)};
}

sub setLocationByNameAndType($$$) {
    return 0 != db::do('update entity set location = ? where entity_name = ? and entity_type = ?', undef, @_);
}

sub setLocationById($$) {
    return 0 != db::do('update entity_instance set location = ? where entity_id = ?', undef, @_);
}

sub createByNameAndTypeAndLocation($$$) {
    my $name = shift;
    my $type = shift;
    my $location = shift;
    db::do('insert into entity_instance(entity_def_id, location, health) select entity_def_id, ?, max_health from entity_def where entity_name = ? and entity_type_id = (select entity_type_id from entity_type where entity_type = ?)', undef, $location, $name, $type);
    return db::selectrow_array('select LAST_INSERT_ID()');
}

sub createByEntityDefIdAndLocation($$) {
    my $entity_def_id = shift;
    my $location = shift;
    return 0 != db::do('insert into entity_instance(entity_def_id, location, health) values(?, ?, (select max_health from entity_def where entity_def_id = ?))', undef, $entity_def_id, $location, $entity_def_id);
}

sub deleteByLocationAndType($$) {
    return db::do('delete e from entity_instance e join entity_def def on def.entity_def_id = e.entity_def_id where e.location=? and def.entity_type_id = (select entity_type_id from entity_type where entity_type = ?)', undef, @_);
}

sub deleteByTypeAndId($$) {
    return db::do('delete e from entity_instance e join entity_def def on def.entity_def_id = e.entity_def_id where def.entity_type_id = (select entity_type_id from entity_type where entity_type = ?) and e.entity_id=?', undef, @_);
}

sub addHealthById($$) {
    my $health = shift;
    my $id = shift;
    my $rows_affected = db::do('update entity_instance set health = health + ? where entity_id = ? AND health is not NULL', undef, $health, $id);

    return undef if $rows_affected == 0;
    return 0 if $health > 0;
    return 1 if 0 != db::do('update entity_instance set location = "root/death" where entity_id = ? and health <= 0 and location != "root/death"', undef, $id);
    return 0;
}

1;