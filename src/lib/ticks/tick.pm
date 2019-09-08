#!/usr/bin/perl
package tick;

use strict;
use warnings;

use lib::ticks::sweep;

sub tick {
    die 'usage: tick $posix_time' unless scalar(@_) == 1;

    unless ($_[0] % 10) {
        sweep();
    }
}

1;
