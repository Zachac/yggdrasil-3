#!/usr/bin/perl
use strict;
use warnings;

use Cwd;
use File::Basename;

use lib dirname(Cwd::realpath($0));

use environment::env;
use lib::model::commands;

die "usage: src/run.pl user command" unless @ARGV >= 1;

commands::runAs(@ARGV);
