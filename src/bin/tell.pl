#!/usr/bin/perl

use strict;
use warnings;

use lib::model::user;

if (@ARGV < 2) {
    print "ERROR: usage: tell user message\n";
    return 0;
}

my $user = shift;

unless (user::tellFrom($user, $ENV{'USERNAME'}, @ARGV)) {
    print "Could not deliver message to $user\n";
}
