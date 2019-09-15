#!/usr/bin/perl

use strict;
use warnings;

use lib::model::user;
use lib::model::commands;

user::setLocation($ENV{'USERNAME'}, shift);
commands::run("look");
