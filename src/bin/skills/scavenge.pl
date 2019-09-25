#!/usr/bin/perl

use strict;
use warnings;

use lib::model::entities::resource;

my $command = shift;

unless (@ARGV > 0) {
    print "usage: $command resource name\n";
    return;
}

my $result = resource::gather($ENV{'USERNAME'}, $command, "@ARGV");

if (defined $result) {
    skills::addExp($ENV{'USERNAME'}, $command, 1);
    print "You find some $result.\n";
} else {
    print "You find nothing.\n";
}
