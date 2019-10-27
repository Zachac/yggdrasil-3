#!/usr/bin/perl

use strict;
use warnings;

use lib::model::user::user;

my $command = shift;

if (@ARGV < 2) {
    user::echo "usage: $command user message\n";
    return 0;
}

my $user = shift;
my $message = "(w) $ENV{'USERNAME'}: @ARGV";

unless (user::tell($user, $message)) {
    user::echo "Could not deliver message to $user\n";
}
