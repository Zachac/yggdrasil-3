#!/usr/bin/perl
# sweep up and clean up the player files for users that
# have disconnected

package tick;

use strict;
use warnings;

use File::Basename;
use lib::model::client;
use lib::model::commmands;

sub sweep {
    foreach (client::getAll()) {
        print "sweeping $_\n";
        commands::runAs($_, "quit") unless client::alive($_);
    }
}

1;