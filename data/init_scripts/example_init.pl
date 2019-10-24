#!/usr/bin/perl
use strict;
use warnings;

use lib::crypto::hash;
use lib::model::user::user;
use lib::model::user::skills;
use lib::model::map::room;

my $username = 'abc';
my $password = 'def';

user::create($username, hash::password($username, $password));
skills::train($username, 'forage');
skills::addExp($username, 'forage', 129);


room::create('root/spawn', 'An empty room', 'It looks like a very normal room.');
player::setLocation($username, 'root/spawn');

1;