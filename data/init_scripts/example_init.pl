#!/usr/bin/perl
use strict;
use warnings;

use lib::crypto::hash;
use lib::model::user::user;
use lib::model::commands::actions;
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


item::register('magic mirror', 'a shiny reflective object, maybe you could use this?');
item::create('magic mirror', 'root/spawn');
actions::set('magic mirror', 'use', 'spawn');

item::register('fire pit kit');
actions::set('fire pit kit', 'use', 'create fire pit', 1);

item::register('fire pit');
actions::set('fire pit', 'light', 'create bonfire', 1);

item::register('bonfire');
actions::set('bonfire', 'touch', 'setspawn');

item::register('leaves');
item::register('rocks');

item::register('broken item');
actions::set('broken item', 'use', 'spawnnn', 1);

resource::register('undergrowth', 'a mix of thick brush and fallen leaves covering the forest ground.');

1;