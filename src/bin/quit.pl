#!/usr/bin/perl

use strict;
use warnings;

use lib::model::client;
use lib::model::user;


user::broadcastOthers($ENV{'USERNAME'}, "$ENV{'USERNAME'} turns to stone");

my $pid = user::pid($ENV{'USERNAME'});

if (defined $pid) {
    client::remove($ENV{'USERNAME'});
    user::unlock($ENV{'USERNAME'});
    kill -9, getpgrp($pid) or die "Could not terminate $ENV{'USERNAME'} successfully!\n";
}
