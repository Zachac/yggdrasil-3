#!/usr/bin/perl

use strict;
use warnings;

use Cwd;

use lib::model::entity;

print entity::getLocation('player', $ENV{'USERNAME'}), "\n";
