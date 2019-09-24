#!/usr/bin/perl
package resource;

use strict;
use warnings;

use lib::model::entities::entity;
use lib::model::entities::player;
use lib::model::skills;

$db::conn->do("CREATE TABLE IF NOT EXISTS resource (
    resource_name NOT NULL,
    skill NOT NULL,
    level NOT NULL DEFAULT 0,
    produces NOT NULL,
    wheight NOT NULL DEFAULT 1
    UNIQUE(resource_name, skill, level, produces)
);");

$db::conn->do("insert or ignore into resource(resource_name, skill, level, produces, wheight) values ('forest undergrowth', 'scavenge', 0, 'leaves', 1)");
$db::conn->do("insert or ignore into resource(resource_name, skill, level, produces, wheight) values ('forest undergrowth', 'scavenge', 0, 'rocks', 1)");

sub use($$$) {
    my $name = shift;
    my $action = shift;
    my $resource = shift;
    my $location = player::getLocation($name);
    my $level = skill::getLevel($name, $action);

    die "Could not find resource $name" unless entity::typeExistsIn($resource, $location, 'resource');
    my @resourceResults = @{$db::conn->selectall_arrayref('select wheight, produces from resource where resource_name = ? and skill = ? and level >= ?', undef, $resource, $action, $level)};
    my $totalWheight = 0;
    $totalWheight += $_[0] for @resourceResults;
    my $selected = rand $totalWheight;

    for (@resourceResults) {
        $totalWheight -= $_[0];
        if ($selectedValue <= $totalWheight) {
            return $_[1];
        }
    }

    return undef;
}

1;