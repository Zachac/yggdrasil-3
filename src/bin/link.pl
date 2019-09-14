#!/usr/bin/perl

use strict;
use warnings;

require lib::model::room;
require lib::model::user;

if (@ARGV < 2) {
    print "ERROR: usage: link destination name\n";
    return 0;
}

unless (room::exists($ARGV[0])) {
    print "ERROR: destination does not exist\n";
    return 0;
}

my $location = user::getLocation($ENV{'USERNAME'});

if (room::addExit($location, $ARGV[0], $ARGV[1])) {
    print "Linked!\n";
} else {
    print "Could not create link: $!\n";
}
