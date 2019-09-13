#!/usr/bin/perl

use strict;
use warnings;

use Cwd;

use lib::model::room;

print room::resolveRelative(Cwd::cwd()), "\n";
