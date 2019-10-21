#!/usr/bin/perl

use strict;
use warnings;

use lib::model::user::user;
use lib::model::entities::player;

my $command = shift;
my $message = "(s) $ENV{'USERNAME'}: @ARGV";

unless ($message =~ /^\s*$/) {
    user::broadcast($ENV{'USERNAME'}, $message);
} else {
    print "usage: $command message\n";
}
