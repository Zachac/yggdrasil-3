#!/usr/bin/perl

use strict;
use warnings;

use lib::model::user;

if (@ARGV < 2) {
    print "usage: tell user message";
}

my $user = shift;

unless (user::tellFrom($user, $ENV{'USERNAME'}, @ARGV)) {
    print "Could not deliver message to $user\n";
}


