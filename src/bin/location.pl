#!/usr/bin/perl

use strict;
use warnings;

use Cwd;

use lib::model::entities::entity;
use lib::model::entities::player;
use lib::model::user::user;

user::echo player::getLocation($ENV{'USERNAME'}), "\n";
