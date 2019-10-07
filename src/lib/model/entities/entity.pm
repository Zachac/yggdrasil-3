#!/usr/bin/perl
package entity;

use strict;
use warnings;

use environment::db;

$db::conn->do("CREATE TABLE IF NOT EXISTS entity_instance (
    entity_id INTEGER NOT NULL PRIMARY KEY,
    entity_name NOT NULL,
    entity_type NOT NULL,
    location
);");

$db::conn->do("CREATE TABLE IF NOT EXISTS entity (
    entity_name NOT NULL,
    entity_type NOT NULL,
    description,
    PRIMARY KEY(entity_name, entity_type)
);");

sub description {
    my $entity_name = shift;
    my $description = $db::conn->selectrow_array('select description from entity where entity_name=?', undef, $entity_name);
    
    return $description if defined $description;
    return 'You don\'t notice anything interesting.';
}

sub getId($$) {
    my $entity_name = shift;
    my $type = shift;
    return $db::conn->selectrow_array('select entity_id from entity_instance where entity_name=? and entity_type=?', undef, $entity_name, $type);
}

sub existsIn {
    my $entity_name = shift;
    my $location = shift;
    return $db::conn->selectrow_array('select entity_type, entity_id from entity_instance where entity_name=? and location=?', undef, $entity_name, $location);
}

sub typeExistsIn($$$) {
    my $entity_name = shift;
    my $location = shift;
    my $type = shift;
    return $db::conn->selectrow_array('select entity_id from entity_instance where entity_type = ? and entity_name=? and location=?', undef, $type, $entity_name, $location);
}

sub getAll {
    my $location = shift;
    return @{$db::conn->selectcol_arrayref('select entity_name from entity_instance where location=?', undef, $location)};
}

sub getAllOfIn {
    my $type = shift;
    my $location = shift;
    return @{$db::conn->selectcol_arrayref('select entity_name from entity_instance where location=? and entity_type=?', undef, $location, $type)};
}

sub getLocation {
    my $type = shift;
    my $name = shift;
    my $id = shift;

    if (defined $id) {
        return $db::conn->selectrow_array('select location from entity_instance where entity_type = ? and entity_name = ? and entity_id = ?', undef, $type, $name, $id);
    } else {
        return $db::conn->selectrow_array('select location from entity_instance where entity_type = ? and entity_name = ?', undef, $type, $name);
    }
}

sub setLocation {
    my $name = shift;
    my $location = shift;
    my $type = shift;
    my $id = shift;

    unless (defined $id) {
        $id = getId($name, $type);
    }

    if (defined $id) {
        return 0 != $db::conn->do('update entity_instance set location = ? where entity_type = ? and entity_name = ? and entity_id = ?', undef, $location, $type, $name, $id);
    } else {
        return 0 != $db::conn->do('insert into entity_instance(location, entity_type, entity_name) values (?, ?, ?)', undef, $location, $type, $name);
    }
}

sub create($$$) {
    my $name = shift;
    my $location = shift;
    my $type = shift;
    return 0 != $db::conn->do('insert or ignore into entity_instance(entity_name, entity_type, location) values (?, ?, ?)', undef, $name, $type, $location);
}

sub deleteAll($$) {
    my ($location, $type) = @_;
    return $db::conn->do('delete from entity_instance where location = ? and entity_type = ?', undef, $location, $type);
}

sub delete($$) {
    my $entity_type = shift;
    my $entity_id = shift;
    return $db::conn->do('delete from entity_instance where entity_id = ? and entity_type = ?', undef, $entity_id, $entity_type);
}

1;