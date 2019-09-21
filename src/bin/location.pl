#!/usr/bin/perl

use strict;
use warnings;

use Cwd;

use lib::model::entities::entity;
use lib::model::entities::player;

print player::getLocation($ENV{'USERNAME'}), "\n";
