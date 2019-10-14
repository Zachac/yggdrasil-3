#!/usr/bin/perl
package item;

use strict;
use warnings;

use lib::model::entities::entity;
use environment::db;
use lib::io::format;


$db::conn->do("CREATE TABLE IF NOT EXISTS item_instance (
    entity_id INTEGER NOT NULL PRIMARY KEY,
    count INTEGER NOT NULL DEFAULT 0
);");

sub getAll($) {
    my $location = shift;
    return entity::getAllOfIn('item', $location);
}

sub find($$) {
    my $name = shift;
    my $location = shift;
    return entity::typeExistsIn($name, $location, 'item');
}

sub isStackable($) {
    return format::isPlural shift;
}

sub getCount($) {
    my $entity_id = shift;
    return $db::conn->seletrow_array('select count from item_instance where entity_id = ?', undef, $entity_id)
            // 1;
}

sub create($$) {
    my $name = shift;
    my $location = shift;
    my $entity_id; 

    if (isStackable $name) {
        $entity_id = find($name, $location);

        if (defined $entity_id) {
            $db::conn->do('insert or ignore into item_instance(entity_id, count) values (?, 1)', undef, $entity_id);
            $db::conn->do('update item_instance set count = count + 1 where entity_id = ?', undef, $entity_id);
        }
    }
    
    unless (defined $entity_id) {
        $entity_id = entity::create($name, $location, 'item');
    }

    return $entity_id;
}

sub setLocation($$$) {
    my $location = shift;
    my $name = shift;
    my $id = shift;
    return entity::setLocation($name, $location, 'item', $id);
}

sub deleteAll($) {
    my $location = shift;
    return entity::deleteAll($location, 'item');
}

sub delete($) {
    my $id = shift;
    return entity::delete('item', $id);
}

1;