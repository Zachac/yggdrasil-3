#!/usr/bin/perl
package client;

use strict;
use warnings;

use Fcntl qw(:DEFAULT :flock O_NONBLOCK O_WRONLY);
use File::Path qw(make_path);

use lib::io::file;
use lib::model::map::room;

use lib::env::env;
use lib::env::db qw(conn);

sub message {
    my $username = shift;
    my $stdout_path = getStdoutPath($username);
    file::mkfifo($stdout_path);
    return file::printnb($stdout_path, @_);
}

sub getStdoutByUsername($;$) {
    my $stdout_path = getStdoutPath(shift);
    my $blocking = shift;
    my $mode = O_RDONLY;

    $mode = $mode | O_NONBLOCK if $blocking;

    file::mkfifo($stdout_path);
    sysopen(my $stdout, $stdout_path, $mode) or die "Could not open $stdout_path!";
    return $stdout;
}

sub getStdoutPath {
    my $fileSafeUsername = quotemeta shift;
    my $stdout_path = "${\(env::dir())}/runtime/clients/$fileSafeUsername.stdout";
    return $stdout_path;
}

sub remove {
    die "No user given" unless @_ == 1;
    my $stdout_path = getStdoutPath @_;
    file::remove($stdout_path);
}

1;