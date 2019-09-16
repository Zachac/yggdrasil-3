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

sub stdout {
    my $username = shift;
    my $open_mode = shift;
    my $stdout_path = getStdoutPath($username);

    file::mkfifo($stdout_path);
    open(my $stdout, $open_mode, $stdout_path) or die "Could not open $stdout_path!";
    return $stdout;
}

sub getStdoutPath {
    my $fileSafeUsername = quotemeta shift;
    my $stdout_path = "$ENV{DIR}/runtime/clients/$fileSafeUsername.stdout";
    return $stdout_path;
}

sub remove {
    die "No user given" unless @_ == 1;
    my $username = shift;
    my $fileSafeUsername = quotemeta $username;
    my $lockFile = "$ENV{DIR}/runtime/clients/$fileSafeUsername.lock";
    my $stdout_path = getStdoutPath $username;

    file::remove($stdout_path);
    file::remove($lockFile);
}

sub alive {
    my $fileSafeUsername = quotemeta shift;
    my $proc_file = "$ENV{DIR}/runtime/clients/$fileSafeUsername.lock";

    if (-e $proc_file) {
        return kill(0, file::slurp($proc_file));
    } else {
        return 0;
    }
}

sub lock {
    my $username = shift;
    my $fileSafeUsername = quotemeta $username;
    my $lockFile = "$ENV{DIR}/runtime/clients/$fileSafeUsername.lock";
    file::initPathTo($lockFile);
    open(my $lock, ">", $lockFile) or die "Couldn't open $lockFile lock: $!";

    return 0 unless flock($lock, LOCK_EX|LOCK_NB);

    $lock->autoflush(1);
    print $lock $$;

    return $lock
}

sub getAll {
    my $dir = "$ENV{DIR}/runtime/clients/";
    return grep {return $1 if ($_ =~ m/(?<=^\Q$dir\E)(.+)(?=\.lock)/g)} glob("$dir*.lock");
}

1;