#!/usr/bin/perl
package entity;

use strict;
use warnings;

use lib::env::db;

sub description {
    my $entity_name = shift;
    my $description = db::selectrow_array('select description from entity_def where entity_name=?', undef, $entity_name);
    
    return $description if defined $description;
    return 'You don\'t notice anything interesting.';
}

sub getId($$) {
    my $entity_name = shift;
    my $type = shift;
    return db::selectrow_array('select entity_id from entity where entity_name=? and entity_type=?', undef, $entity_name, $type);
}

sub existsIn {
    my $entity_name = shift;
    my $location = shift;
    return db::selectrow_array('select entity_type, entity_id from entity where entity_name=? and location=?', undef, $entity_name, $location);
}

sub typeExistsIn($$$) {
    my $entity_name = shift;
    my $location = shift;
    my $type = shift;
    return db::selectrow_array('select entity_id from entity where entity_type = ? and entity_name=? and location=?', undef, $type, $entity_name, $location);
}

sub getAll {
    my $location = shift;
    return @{db::selectcol_arrayref('select entity_name from entity where location=?', undef, $location)};
}

sub getAllEx {
    my $location = shift;
    return db::selectall_arrayref('select entity_name, entity_type, entity_id from entity where location=?', undef, $location);
}

sub getEntityNamesByTypeAndLocation {
    my $type = shift;
    my $location = shift;
    return @{db::selectcol_arrayref('select entity_name from entity where location=? and entity_type=?', undef, $location, $type)};
}

sub getNamesAndEntityIdsByTypeAndLocation {
    my $type = shift;
    my $location = shift;
    return @{db::selectall_arrayref('select entity_name, entity_id from entity where location=? and entity_type=?', undef, $location, $type)};
}

sub getEntityIdsByNameAndLocation {
    my $name = shift;
    my $location = shift;
    return @{db::selectcol_arrayref('select entity_id from entity where location=? and entity_name=?', undef, $location, $name)};
}

sub getLocationByTypeAndName {
    my $type = shift;
    my $name = shift;
    return db::selectrow_array('select location from entity where entity_type = ? and entity_name = ?', undef, $type, $name);
}

sub setLocationByNameAndType($$$) {
    my $location = shift;
    my $name = shift;
    my $type = shift;
    return 0 != db::do('update entity set location = ? where entity_name = ? and entity_type = ?', undef, $location, $name, $type);
}

sub setLocationById($$) {
    my $location = shift;
    my $id = shift;
    return 0 != db::do('update entity_instance set location = ? where entity_id = ?', undef, $location, $id);
}

sub create($$$) {
    my $name = shift;
    my $location = shift;
    my $type = shift;
    
    db::do('insert into entity_instance(entity_def_id, location) values ((select entity_def_id from entity_def where entity_name = ? and entity_type_id = (select entity_type_id from entity_type where entity_type = ?)), ?)', undef, $name, $type, $location);
    return db::selectrow_array('select LAST_INSERT_ID()');
}

sub deleteByLocationAndType($$) {
    my ($location, $type) = @_;
    return db::do('delete e from entity_instance e join entity_def def on def.entity_def_id = e.entity_def_id where e.location=? and def.entity_type_id = (select entity_type_id from entity_type where entity_type = ?)', undef, $location, $type);
}

sub deleteByTypeAndId($$) {
    my $entity_type = shift;
    my $entity_id = shift;
    return db::do('delete e from entity_instance e join entity_def def on def.entity_def_id = e.entity_def_id where e.entity_id=? and def.entity_type_id = (select entity_type_id from entity_type where entity_type = ?)', undef, $entity_id, $entity_type);
}

1;