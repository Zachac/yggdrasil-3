#!/usr/bin/perl
package client;

use strict;
use warnings;

use Fcntl qw(:DEFAULT :flock);
use File::Path qw(make_path);

use lib::io::file;
use lib::model::room;

use environment::db qw(conn);

sub message {
    my $username = shift;
    my $message = shift;
    my $stdout_path = getStdoutPath($username);
    file::mkfifo($stdout_path);
    return file::printnb($stdout_path, $message);
}

sub getStdout {
    my $stdout_path = getStdoutPath(shift);

    file::mkfifo($stdout_path);
    open(my $stdout, "<", $stdout_path) or die "Could not open $stdout_path!";
    return $stdout;
}

sub getStdoutPath {
    my $fileSafeUsername = quotemeta shift;
    my $stdout_path = "$ENV{DIR}/runtime/clients/$fileSafeUsername.stdout";
    return $stdout_path;
}

sub remove {
    die "No user given" unless @_ == 1;
    my $stdout_path = getStdoutPath @_;
    file::remove($stdout_path);
}

1;