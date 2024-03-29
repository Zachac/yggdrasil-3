#!/usr/bin/perl

use strict;
use warnings;

use lib::model::user::client;
use lib::model::user::user;


user::broadcastOthers($ENV{'USERNAME'}, "$ENV{'USERNAME'} eye's glaze over");

my $pid = user::pid($ENV{'USERNAME'});

if (defined $pid) {
    client::remove($ENV{'USERNAME'});
    user::unlock($ENV{'USERNAME'});
    kill -9, getpgrp($pid) or die "Could not terminate $ENV{'USERNAME'} successfully!\n";
}
