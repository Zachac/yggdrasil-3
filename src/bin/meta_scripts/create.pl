#!/usr/bin/perl

use strict;
use warnings;

use lib::model::entities::item;
use lib::model::entities::player;
use lib::io::format;
use lib::model::user::user;

my $command = shift;
my $item_type = $ARGV[0] =~ /^-/ ? substr(shift, 1) : 'item' if @ARGV > 0;

die "usage: $command [-entity_type] item name\n" unless @ARGV > 0;

my $item_name = "@ARGV";
my $location = player::getLocation($ENV{'USERNAME'});
my $an_item_name = format::withArticle($item_name);
my $result;

if ($item_type eq 'item') {
    $result = item::create($item_name, $location);
} else {
    $result = entity::createByNameAndTypeAndLocation($item_name, $item_type, $location);
}

die "could not create $item_name\n" unless $result;

user::echo "Created $an_item_name!\n";

1;