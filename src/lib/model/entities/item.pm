#!/usr/bin/perl
package item;

use strict;
use warnings;

use lib::model::entities::entity;
use lib::model::entities::entity_type;
use lib::model::entities::entity_def;
use lib::env::db;
use lib::io::format;

my $type = entity_type::register('item');

sub register($;$) {
    my $name = shift;
    my $description = shift;
    entity_def::register($name, 'item', $description);
}

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

sub findCount($$) {
    my $name = shift;
    my $location = shift;
    my $id = find($name, $location);

    return 0 unless defined $id;
    return getCount($id);
}

sub getCount($) {
    my $entity_id = shift;
    return db::selectrow_array('select count from item_instance where entity_id = ?', undef, $entity_id);
}

sub addCount($$) {
    my $entity_id = shift;
    my $count = shift;
    db::do('insert into item_instance(entity_id, count) values (?, ?) on duplicate key update count = count + ?', undef, $entity_id, $count, $count);
}

sub mergeCounts($$) {
    my $entity_id1 = shift;
    my $entity_id2 = shift;
    my $add_count = getCount($entity_id2);

    addCount($entity_id1, $add_count);
    entity::deleteByTypeAndId('item', $entity_id2);

    return 1;
}

sub create($$;$) {
    my $name = shift;
    my $location = shift;
    my $count = shift // 1;
    
    die "Cannot create negative amount of items\n" if $count < 0;

    my $entity_id = find($name, $location) // entity::create($name, $location, 'item');
    addCount($entity_id, $count);
    return $entity_id;
}

sub setLocationByIdAndName($$$) {
    my $location = shift;
    my $id = shift;
    my $name = shift;
    my $other_id = find($name, $location);

    return mergeCounts($other_id, $id) if (defined $other_id);
    return entity::setLocationById($location, $id);
}

sub setLocationByNameAndLocation($$$) {
    my $location1 = shift;
    my $name = shift;
    my $location2 = shift;
    my $id = find($name, $location2);
    return setLocationByIdAndName($location1, $id, $name)
}

sub cleanEmptyStacks() {
    return db::do('delete from entity_instance where entity_id IN (select entity_id from item_instance where count <= 0)');
}

sub moveByNameAndLocationAndCountToLocation($$$$) {
    my $name = shift;
    my $location1 = shift;
    my $count = shift;
    my $location2 = shift;
    my $id = find($name, $location1);

    return undef unless defined $id;

    my $removed = 0 != db::do('update item_instance set count = count - ? where entity_id = ? and count >= ?', undef, $count, $id, $count);
    return undef unless $removed;

    cleanEmptyStacks();
    my $new_id = create($name, $location2, $count);
    return $new_id;
}

sub deleteByLocation($) {
    my $location = shift;
    return entity::deleteByLocationAndType($location, 'item');
}

sub deleteById($) {
    my $id = shift;
    return entity::deleteByTypeAndId('item', $id);
}

1;