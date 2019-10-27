#!/usr/bin/perl

use strict;
use warnings;

use lib::model::user::skills;
use lib::model::user::user;

skills::requireLevel "punch", 1;

user::echo "You punch at the air futiley.\n";
