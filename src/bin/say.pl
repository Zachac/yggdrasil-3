#!/usr/bin/perl

use strict;
use warnings;

use lib::model::user;
use lib::model::room;

my $message = "@ARGV";
my $location = room::resolve(user::getLocation($ENV{'USERNAME'}));

unless ($message =~ /^\s*$/) {
    user::tellFrom($_, $ENV{'USERNAME'}, $message) for room::getUsers($location);
}
