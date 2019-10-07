#!/usr/bin/perl
package foo;

use strict;
use warnings;

use lib::model::entities::resource;
use lib::model::inventory;


sub create($) {
    my $item = shift;    
    die "you already have a $item\n" if defined inventory::find($ENV{'USERNAME'}, $item);
    inventory::add($ENV{'USERNAME'}, $item);
}

# print resource::create('forest undergrowth', 'root/spawn'), "\n";
# print rand(), "\n";

# create('magic mirror');
create('broken item');
