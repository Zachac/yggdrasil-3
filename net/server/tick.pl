#!/usr/bin/perl
use strict;
use warnings;

sub tick {
    die 'usage: tick $posix_time' unless scalar(@_) == 1;

    unless ($_[0] % 10) {
        print "sweeping\n";
        system "$ENV{DIR}/net/server/sweep.sh";
    }
}

1;
