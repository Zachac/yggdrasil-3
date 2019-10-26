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

sub setLocationByNameAndType($$$) {
    return 0 != db::do('update entity set location = ? where entity_name = ? and entity_type = ?', undef, @_);
}

sub setLocationById($$) {
    return 0 != db::do('update entity_instance set location = ? where entity_id = ?', undef, @_);
}

sub createByNameAndTypeAndLocation($$$) {
    db::do('insert into entity_instance(entity_def_id, location) values ((select entity_def_id from entity_def where entity_name = ? and entity_type_id = (select entity_type_id from entity_type where entity_type = ?)), ?)', undef, @_);
    return db::selectrow_array('select LAST_INSERT_ID()');
}

sub deleteByLocationAndType($$) {
    return db::do('delete e from entity_instance e join entity_def def on def.entity_def_id = e.entity_def_id where e.location=? and def.entity_type_id = (select entity_type_id from entity_type where entity_type = ?)', undef, @_);
}

sub deleteByTypeAndId($$) {
    return db::do('delete e from entity_instance e join entity_def def on def.entity_def_id = e.entity_def_id where def.entity_type_id = (select entity_type_id from entity_type where entity_type = ?) and e.entity_id=?', undef, @_);
}

1;