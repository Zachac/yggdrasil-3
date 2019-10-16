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
    return entity::getEntityNamesByTypeAndLocation('item', $location);
}

sub getNamesAndCountsByLocation($) {
    my $location = shift;
    my @results = entity::getNamesAndEntityIdsByTypeAndLocation('item', $location);

    @$_[1] = getCount(@$_[1]) for @results;

    return @results;
}

sub find($$) {
    my $name = shift;
    my $location = shift;
    return entity::typeExistsIn($name, $location, 'item');
}

sub isStackable($) {
    return format::isPlural shift;
}

sub findCount($$) {
    my $name = shift;
    my $location = shift;
    my $id = find($name, $location);

    return 0 unless defined $id;
    return 1 unless isStackable $name;
    return getCount($id);
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

sub create($$;$);
sub create($$;$) {
    my $name = shift;
    my $location = shift;
    my $count = shift // 1;
    
    if (isStackable $name) {
        my $entity_id = find($name, $location);

        if (defined $entity_id) {
            addCount($entity_id, $count);
            return $entity_id;
        }
    }
    
    entity::create($name, $location, 'item') or die "could not create entity for new item $name\n";

    return 1 if ($count <= 1);
    return create($name, $location, $count - 1);
}

sub setLocationByIdAndName($$$) {
    my $location = shift;
    my $id = shift;
    my $name = shift;

    return 0 unless defined $id;

    if (isStackable $name) {
        my $entity_id = find($name, $location);

        if (defined $entity_id) {
            my $temp_location = "p:$$";
            my $moved = entity::setLocationById($temp_location, $id);
            return 0 unless $moved;
            return mergeCounts($entity_id, $id);
        }
    }

    return entity::setLocationById($location, $id);
}

sub setLocationByNameAndLocation($$$) {
    my $location1 = shift;
    my $name = shift;
    my $location2 = shift;
    my $id = find($name, $location2);
    return setLocationByIdAndName($location1, $id, $name)
}

sub splitByNameAndLocationAndCountToLocation($$$$) {
    my $name = shift;
    my $location1 = shift;
    my $count = shift;
    my $location2 = shift;

    my $id = find($name, $location1);
    return undef unless defined $id;

    my $removed = 0 != $db::conn->do('update item_instance set count = count - ? where entity_id = ? and count >= ?', undef, $count, $id, $count);
    return undef unless $removed;

    my $deleted = 0 != $db::conn->do('delete from item_instance where count = 0 and entity_id = ?', undef, $id);
    entity::delete('item', $id) if $deleted;

    return create($name, $location2, $count);
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