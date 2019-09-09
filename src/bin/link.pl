#!/usr/bin/perl

use strict;
use warnings;

require lib::model::room;

if (@ARGV < 2) {
    print "ERROR: usage: link detination name\n";
    return 0;
}

unless (room::isValidRoomPath($ARGV[0])) {
    print "ERROR: Invalid room path\n";
    return 0;
}

my $destination = room::resolve($ARGV[0]);

unless (room::exists($destination)) {
    print "ERROR: destination does not exist\n";
    return 0;
}

if (room::addExit(".", $destination, $ARGV[1])) {
    print "Linked!\n";
} else {
    print "Could not create link: $!\n";
}
