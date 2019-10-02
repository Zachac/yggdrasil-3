#!/usr/bin/perl

use strict;
use warnings;

use Math::Fractal::Noisemaker;

use lib::model::map;

my $command = shift;


print map::get(shift, shift, shift);
