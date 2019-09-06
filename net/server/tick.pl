#!/usr/bin/perl
use strict;
use warnings;

require "$ENV{SWEEP}";

sub tick {
    die 'usage: tick $posix_time' unless scalar(@_) == 1;

    unless ($_[0] % 10) {
        sweep();
    }
}

1;
