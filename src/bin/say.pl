#!/usr/bin/perl

use strict;
use warnings;

use lib::model::user;
use lib::model::player_list;


print "$_\n" for player_list::get();