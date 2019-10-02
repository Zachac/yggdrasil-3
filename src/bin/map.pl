#!/usr/bin/perl

use strict;
use warnings;

use lib::model::map;

my $command = shift;


print map::get(shift, shift, shift);
