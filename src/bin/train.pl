#!/usr/bin/perl

use strict;
use warnings;

use lib::model::skills;

die "usage: $ARGV[0] skill\n" unless (@ARGV == 2);

skills::train(lc $ARGV[1]);
print "Level up!\n";


