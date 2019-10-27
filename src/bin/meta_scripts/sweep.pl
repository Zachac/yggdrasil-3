#!/usr/bin/perl

use strict;
use warnings;

use lib::ticks::sweep;
use lib::model::user::user;

tick::sweep();
user::echo "Swept!\n";

1;