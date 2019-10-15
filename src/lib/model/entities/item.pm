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
    return $db::conn->selectrow_array('select count from item_instance where entity_id = ?', undef, $entity_id)
            // 1;
}

sub addCount($$) {
    my $entity_id = shift;
    my $count = shift;

    $db::conn->do('insert or ignore into item_instance(entity_id, count) values (?, 1)', undef, $entity_id);
    $db::conn->do('update item_instance set count = count + ? where entity_id = ?', undef, $count, $entity_id);
}

sub mergeCounts($$) {
    my $entity_id1 = shift;
    my $entity_id2 = shift;
    my $add_count = getCount($entity_id2);

    addCount($entity_id1, $add_count);
    $db::conn->do('delete from item_instance where entity_id = ?', undef, $entity_id2);
    entity::delete('item', $entity_id2);

    return 1;
}

sub create($$) {
    my $name = shift;
    my $location = shift;
    
    if (isStackable $name) {
        my $entity_id = find($name, $location);

        if (defined $entity_id) {
            addCount($entity_id, 1);
            return $entity_id;
        }
    }
    
    return entity::create($name, $location, 'item');;
}

sub setLocation($$$) {
    my $location = shift;
    my $name = shift;
    my $id = shift;
    my $entity_id;

    if (isStackable $name) {
        $entity_id = find($name, $location);

        if (defined $entity_id) {
            my $temp_location = "p:$$";
            my $moved = entity::setLocation($name, $temp_location, 'item', $id);
            return 0 unless $moved;
            return mergeCounts($entity_id, $id);
        }
    }

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