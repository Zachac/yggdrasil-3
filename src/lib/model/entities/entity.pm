#!/usr/bin/perl
package entity;

use strict;
use warnings;

use environment::db;

$db::conn->do("CREATE TABLE IF NOT EXISTS entity_instance (
    entity_name NOT NULL,
    entity_type NOT NULL DEFAULT 'entity',
    entity_id NOT NULL DEFAULT 0,
    location,
    PRIMARY KEY(entity_name, entity_type, entity_id)
);");

$db::conn->do("CREATE TABLE IF NOT EXISTS entity (
    entity_name NOT NULL,
    entity_type NOT NULL DEFAULT 'entity',
    entity_id NOT NULL DEFAULT 0,
    description,
    PRIMARY KEY(entity_name, entity_type, entity_id)
);");

sub description {
    my $entity_name = shift;
    my $description = $db::conn->selectrow_array('select description from entity where entity_name=?', undef, $entity_name);
    
    return $description if defined $description;
    return 'You don\'t notice anything interesting.';
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

    $type = 'entity' unless defined $type;
    $id = 0 unless defined $id;

    return $db::conn->selectrow_array('select location from entity_instance where entity_type = ? and entity_name = ? and entity_id = ?', undef, $type, $name, $id)
}

sub setLocation {
    my $name = shift;
    my $location = shift;
    my $type = shift;
    my $id = shift;

    $type = 'entity' unless defined $type;
    $id = 0 unless defined $id;

    my $created = 0 == $db::conn->do('insert or ignore into entity_instance(location, entity_type, entity_Name, entity_id) values (?, ?, ?, ?)', undef, $location, $type, $name, $id);
    
    if ($created) {
        $db::conn->do('update entity_instance set location = ? where entity_type = ? and entity_name = ? and entity_id = ?', undef, $location, $type, $name, $id);
    }

    return $created;
}

1;