#!/usr/bin/perl
use strict;
use warnings;

use File::Basename;
use Cwd;

use lib dirname(Cwd::realpath($0));

use lib::env::env;
use lib::io::file;
use lib::io::stdio;

my $fh = file::lock("${\(env::dir())}/runtime/tick_daemon.log");

unless (defined $fh and fork) {
    setpgrp();
    stdio::setStdout $fh;
    stdio::setStderr $fh;
    stdio::log "Starting up tick daemon!";

    require lib::model::user::user;
    require lib::ticks::tick;

    my $nextime = time;
    while (user::getOnline()) {
        my $thistime = time;

        tick::tick($_) for $nextime .. $thistime;
        $nextime = $thistime + 1;
        sleep 1;
    }

    stdio::log "Shutting down tick daemon!";
}

1;