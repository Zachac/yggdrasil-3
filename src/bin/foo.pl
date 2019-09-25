#!/usr/bin/perl

use strict;
use warnings;

use lib::model::entities::resource;


print resource::create('forest undergrowth', 'root/spawn'), "\n";
