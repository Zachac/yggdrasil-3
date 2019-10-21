#!/usr/bin/perl
use strict;
use warnings;

use Cwd;
use File::Basename;
use English qw(-no_match_vars);

use lib dirname(Cwd::realpath($0));

use lib::env::env;
use lib::model::commands::commands;

die "usage: $PROGRAM_NAME user command\n  (runs a command as a user)\n" unless @ARGV >= 1;

commands::runAs(@ARGV);

1;