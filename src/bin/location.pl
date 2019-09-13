#!/usr/bin/perl

use strict;
use warnings;

use Cwd;

use lib::model::user;

print user::getLocation($ENV{'USERNAME'}), "\n";
