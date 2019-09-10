#!/usr/bin/perl

use strict;
use warnings;

use Cwd;

require lib::model::room;

print room::resolveRelative(Cwd::cwd()), "\n";
