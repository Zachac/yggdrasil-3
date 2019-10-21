#!/usr/bin/perl

use strict;
use warnings;

use lib::model::user::skills;

skills::requireLevel "punch", 1;

print "You punch at the air futiley.\n";
