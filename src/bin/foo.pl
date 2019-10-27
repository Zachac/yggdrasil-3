#!/usr/bin/perl
package foo;

use strict;
use warnings;

use lib::model::entities::resource;
use lib::model::user::inventory;
use lib::model::user::user;
use lib::io::format;
use lib::io::db;
use lib::env::db;
use lib::env::env;




# my @matches = (1, 2, 3);
# user::echo inflect("<#i:$#matches> <N:matches> <V:were> found"), "\n";

# user::echo resource::create('forest undergrowth', 'root/spawn'), "\n";
# user::echo rand(), "\n";


sub create($) {
    my $item = shift;        
    my $value = format::withArticle($item);

    die "you already have $value\n" if defined inventory::find($ENV{'USERNAME'}, $item);
    return inventory::add($ENV{'USERNAME'}, $item);
}

# create('magic mirror');
# create('broken item');
# create('trees');

# user::echo @{db::selectcol_arrayref('select count(1) from user where user_name like "abc"')}, "\n";

db::loadFile(env::dir() . "/data/tables/actions.yml");
# db::dump();

