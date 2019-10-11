#!/usr/bin/perl

use strict;
use warnings;

use lib::model::commands;

use Time::HiRes qw(sleep);
use Scalar::Util qw(looks_like_number);

my $command = shift;
my $count = shift;

die "usage: $command count [command]\n" unless looks_like_number $count;

while ($count > 0) {
    $count--;

    if (@ARGV > 0) {
        commands::runNoNewLine(@ARGV);
    }

    sleep 0.4;
}

print "finished repeat\n";
