#!/usr/bin/perl
package combat::actions;

use strict;
use warnings;

use lib::model::entities::entity;
use lib::model::entities::entity_drop;
use lib::model::entities::item;
use lib::model::user::inventory;
use lib::model::user::user;


sub damage($$$;$) {
    my $target = shift;
    my $location = shift;
    my $damage = shift;
    my $attackerName = shift // $ENV{'USERNAME'};
    
    die "No target given\n" unless defined $target;
    die "Cannot determine source of damage\n" unless defined $attackerName;

    my $entity_id = entity::getIdByNameAndLocation($target, $location);
    die "Cannot attack, unable to find $target\n" unless defined $entity_id;

    my $killed = entity::addHealthById(-$damage, $entity_id);
    die "Cannot harm immortal object\n" unless defined $killed;
    
    my $isTargetPlayer = player::getIsPlayerByName($target);
    my $prefixedName = $isTargetPlayer ? $target : "the $target";
    user::broadcastAction($attackerName, "hit $prefixedName for $damage points of damage\n", $location);

    if ($killed) {
        processDeathByIdAndNameAndLocation($entity_id, $target, $location);
        $ENV{'TARGET'} = undef;
    } else {
        $ENV{'TARGET'} = $target;
    }

    return $killed;
}

sub processDeathByIdAndNameAndLocation($$$;$) {
    my $entity_id = shift;
    my $name = shift;
    my $location = shift;
    my $isTargetPlayer = shift // player::getIsPlayerByName($name);
    my @death_message = ();

    if ($isTargetPlayer) {
        commands::runAs($name, "look");
        user::echo "You died!\n";
        inventory::dump($name, $location);
    } else {
        push @death_message, "The ";
    }

    push @death_message, $name, " dies";
    for my $drop (entity_drop::getItemNameAndCountsByEntityName($name)) {
        item::create(@$drop[0], $location, @$drop[1]);
        push @death_message, "\n  Drops ", @$drop[0], " ", "x", @$drop[1];
    }

    push @death_message, "\n";
    user::broadcast(undef, join('', @death_message), $location);
}

1;