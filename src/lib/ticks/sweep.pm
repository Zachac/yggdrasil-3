#!/usr/bin/perl
# sweep up and clean up the player files for users that
# have disconnected

package tick;

use strict;
use warnings;

use lib::model::commands;
use lib::model::user::user;

sub sweep {
    foreach (user::getOnline()) {
        commands::runAs($_, "quit") unless user::getPidAliveByUsername($_);
    }
}

1;