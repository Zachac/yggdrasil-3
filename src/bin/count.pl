#!/usr/bin/perl

use strict;
use warnings;

use lib::model::entities::player;
use lib::model::entities::item;


use Lingua::EN::Inflexion qw( inflect );

my $command = shift;

die "usage: $command item name\n" unless @ARGV > 0;

my $item_name = "@ARGV";
my $location = player::getLocation $ENV{'USERNAME'};
my $count = item::findCount($item_name, $location);

$count-- if ($count);
$count += entity::getEntityIdsByNameAndLocation($item_name, $location);

print inflect "You count <#w:$count> <N:$item_name>\n";

