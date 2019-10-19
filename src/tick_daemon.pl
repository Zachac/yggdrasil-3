#!/usr/bin/perl
use strict;
use warnings;

use File::Basename;
use Cwd;

use lib dirname(Cwd::realpath($0));

use environment::env;
use lib::io::file;
use lib::io::stdio;

my $fh = file::lock("${\(env::dir())}/runtime/tick_daemon.log");

unless (defined $fh and fork) {
    setpgrp();
    stdio::setStdout $fh;
    stdio::setStderr $fh;
    stdio::log "Starting up tick daemon!";

    require lib::model::user;
    require lib::ticks::tick;

    my $nextime = time;
    while (user::getOnline()) {
        my $thistime = time;

        tick::tick($_) for $nextime .. $thistime;
        $nextime = $thistime + 1;
        sleep 1;
    }

    stdio::log "Shutting down tick daemon!";
} else {
    print "unable to obtain lock\n" unless defined $fh;
    print "here\n";
}

1;