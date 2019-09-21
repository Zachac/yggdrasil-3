#!/usr/bin/perl

use strict;
use warnings;

use lib::model::user;
use lib::model::player;

my $message = "@ARGV";
my $location = player::getLocation($ENV{'USERNAME'});

unless ($message =~ /^\s*$/) {
    user::tellFrom($_, $ENV{'USERNAME'}, $message) for player::getAll($location);
}
