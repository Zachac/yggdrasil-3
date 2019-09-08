#!/usr/bin/perl
# sweep up and clean up the player files for users that
# have disconnected

package tick;

use strict;
use warnings;

use File::Basename;
use lib::model::user;
use lib::model::player_list;

sub sweep {
    foreach (player_list::get()) {
        user::clean($_) unless user::processAlive($_);
    }
}

1;