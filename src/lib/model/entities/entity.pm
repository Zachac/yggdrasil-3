#!/usr/bin/perl
package entity;

use strict;
use warnings;

use environment::db;

sub description {
    my $entity_name = shift;
    my $description = db::selectrow_array('select description from entity where entity_name=?', undef, $entity_name);
    
    return $description if defined $description;
    return 'You don\'t notice anything interesting.';
}

sub getId($$) {
    my $entity_name = shift;
    my $type = shift;
    return db::selectrow_array('select entity_id from entity_instance where entity_name=? and entity_type=?', undef, $entity_name, $type);
}

sub existsIn {
    my $entity_name = shift;
    my $location = shift;
    return defined db::selectrow_array('select entity_type, entity_id from entity_instance where entity_name=? and location=?', undef, $entity_name, $location);
}

sub typeExistsIn($$$) {
    my $entity_name = shift;
    my $location = shift;
    my $type = shift;
    return defined db::selectrow_array('select entity_id from entity_instance where entity_type = ? and entity_name=? and location=?', undef, $type, $entity_name, $location);
}

sub getAll {
    my $location = shift;
    return @{db::selectcol_arrayref('select entity_name from entity_instance where location=?', undef, $location)};
}

sub getAllEx {
    my $location = shift;
    return db::selectall_arrayref('select entity_name, entity_type, entity_id from entity_instance where location=?', undef, $location);
}

sub getEntityNamesByTypeAndLocation {
    my $type = shift;
    my $location = shift;
    return @{db::selectcol_arrayref('select entity_name from entity_instance where location=? and entity_type=?', undef, $location, $type)};
}

sub getNamesAndEntityIdsByTypeAndLocation {
    my $type = shift;
    my $location = shift;
    return @{db::selectall_arrayref('select entity_name, entity_id from entity_instance where location=? and entity_type=?', undef, $location, $type)};
}

sub getEntityIdsAndNameAndLocation {
    my $name = shift;
    my $location = shift;
    return @{db::selectcol_arrayref('select entity_id from entity_instance where location=? and entity_name=?', undef, $location, $name)};
}

sub getLocation {
    my $type = shift;
    my $name = shift;
    my $id = shift;

    if (defined $id) {
        return db::selectrow_array('select location from entity_instance where entity_type = ? and entity_name = ? and entity_id = ?', undef, $type, $name, $id);
    } else {
        return db::selectrow_array('select location from entity_instance where entity_type = ? and entity_name = ?', undef, $type, $name);
    }
}

sub setLocationByNameAndType($$$) {
    my $location = shift;
    my $name = shift;
    my $type = shift;
    return 0 != db::do('update entity_instance set location = ? where entity_name = ? and entity_type = ?', undef, $location, $name, $type);
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
    return 0 != db::do('insert ignore into entity_instance(entity_name, entity_type, location) values (?, ?, ?)', undef, $name, $type, $location);
}

sub deleteAll($$) {
    my ($location, $type) = @_;
    return db::do('delete from entity_instance where location = ? and entity_type = ?', undef, $location, $type);
}

sub delete($$) {
    my $entity_type = shift;
    my $entity_id = shift;
    return db::do('delete from entity_instance where entity_id = ? and entity_type = ?', undef, $entity_id, $entity_type);
}

1;