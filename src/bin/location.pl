#!/usr/bin/perl

use strict;
use warnings;

use Cwd;

use lib::model::entity;
use lib::model::player;

print player::getLocation($ENV{'USERNAME'}), "\n";
