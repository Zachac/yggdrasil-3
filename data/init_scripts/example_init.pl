#!/usr/bin/perl
use strict;
use warnings;

use lib::crypto::hash;
use lib::model::user::user;
use lib::model::user::skills;
use lib::model::map::room;

use lib::model::entities::item;
use lib::model::entities::resource;


my $username = 'abc';
my $password = 'def';

user::create($username, hash::password($username, $password));
skills::train($username, 'forage');
skills::addExp($username, 'forage', 129);


room::create('root/spawn', 'An empty room', 'It looks like a very normal room.');
player::setLocation($username, 'root/spawn');


item::register('magic mirror', undef);
item::create('magic mirror', 'root/spawn');

item::register('bonfire', undef);
item::register('fire pit', undef);
item::register('leaves', undef);
item::register('rocks', undef);
item::register('fire pit kit', undef);
item::register('broken item', undef);

resource::register('undergrowth', 'a mix of thick brush and fallen leaves covering the forest ground.');

1;