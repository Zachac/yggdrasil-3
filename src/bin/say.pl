#!/usr/bin/perl

use strict;
use warnings;

use lib::model::user;
use lib::model::entity;
use lib::model::room;

my $message = "@ARGV";
my $location = entity::getLocation('player', $ENV{'USERNAME'});

unless ($message =~ /^\s*$/) {
    user::tellFrom($_, $ENV{'USERNAME'}, $message) for entity::getAllOf($location, 'player');
}
