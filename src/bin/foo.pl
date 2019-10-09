#!/usr/bin/perl
package foo;

use strict;
use warnings;

use lib::model::entities::resource;
use lib::model::inventory;
use lib::io::format;
use environment::db;



# my @matches = (1, 2, 3);
# print inflect("<#i:$#matches> <N:matches> <V:were> found"), "\n";

# print resource::create('forest undergrowth', 'root/spawn'), "\n";
# print rand(), "\n";


sub create($) {
    my $item = shift;        
    my $value = format::withArticle($item);

    die "you already have $value\n" if defined inventory::find($ENV{'USERNAME'}, $item);
    inventory::add($ENV{'USERNAME'}, $item);
}

# create('magic mirror');
# create('broken item');
# create('trees');

print @{$db::conn->selectcol_arrayref('select count(1) from user where user_name like "abc"')}, "\n";


