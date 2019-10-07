#!/usr/bin/perl

use strict;
use warnings;

use lib::model::entities::resource;
use lib::model::inventory;


# print resource::create('forest undergrowth', 'root/spawn'), "\n";
# print rand(), "\n";

die "you already have a magic mirror\n" if defined inventory::find($ENV{'USERNAME'}, 'magic mirror');
inventory::add($ENV{'USERNAME'}, 'magic mirror');