#!/usr/bin/perl

use strict;
use warnings;

use lib::model::entities::item;
use lib::model::entities::player;
use lib::io::format;


my $command = shift;

die "usage: $command item name\n" unless @ARGV > 0;

my $item_name = "@ARGV";
my $location = player::getLocation($ENV{'USERNAME'});
my $an_item_name = format::withArticle($item_name);

die "could not create $item_name\n" unless item::create($item_name, $location);

print "created $an_item_name\n";

1;