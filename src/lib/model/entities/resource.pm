#!/usr/bin/perl
package resource;

use strict;
use warnings;

use lib::model::entities::entity;
use lib::model::entities::player;
use lib::model::skills;
use lib::model::inventory;


sub gather($$$) {
    my $name = shift;
    my $action = shift;
    my $resource = shift;
    my $location = player::getLocation($name);
    my $level = skills::getLevel($name, $action);

    die "Could not find resource: $resource\n" unless entity::typeExistsIn($resource, $location, 'resource');
    my @resourceResults = @{db::selectall_arrayref("select wheight, produces from resource where resource_name = ? and skill = ? and level <= ?", undef, $resource, $action, $level)};
    my $totalWheight = 0;
    $totalWheight += @{$_}[0] for @resourceResults;

    my $selected = rand $totalWheight;
    for (@resourceResults) {
        my ($wheight, $item) = @{$_};
        $totalWheight -= $wheight;
        if ($selected >= $totalWheight) {
            inventory::add($name, $item) if defined $item;
            return $item;
        }
    }

    return undef;
}

sub create($$) {
    my $name = shift;
    my $location = shift;
    return entity::create($name, $location, 'resource');
}

1;