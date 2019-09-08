#!/usr/bin/perl
package user;

use strict;
use warnings;

use Fcntl qw(:DEFAULT :flock);

use lib::io::file;
use lib::model::player_list;
use lib::model::room;

sub isValidUsername {
    "@_" =~ m/^[a-zA-Z0-9]{3,}$/
}

sub exists {
    -e "$ENV{DIR}/data/users/@_/password";
}

sub tellFrom {
    my $username = shift;
    my $source = shift;
    my $stdout_path = "$ENV{DIR}/data/users/$username/stdout";
    my $message = "$source: @_";
    
    file::printnb($stdout_path, $message) or return 0;
    return 1;
}

sub stdout {
    my $username = shift;
    my $open_mode = shift;
    my $stdout_path = "$ENV{DIR}/data/users/$username/stdout";

    unless ( -e $stdout_path) {
        system("mkfifo", "$stdout_path");
    }

    open(my $stdout, $open_mode, $stdout_path) or die "Could not open $stdout_path!";


    return $stdout;
}

sub login {
    my $username = shift;
    my $password = shift;

    my $realPass = file::slurp("$ENV{DIR}/data/users/$username/password");
    
    open(my $lock, ">", "$ENV{DIR}/data/users/$username/lock");

    die "User is already logged in!" unless (flock( $lock, LOCK_EX|LOCK_NB ));
    die "Passwords do not match!" unless ($realPass eq $password);

    $ENV{'USERNAME'}=$username;
    file::print("$ENV{DIR}/data/users/$username/proc", $$);
    player_list::add($username);

    return $lock;
}

sub clean {
    die "No user given" unless @_ == 1;
    my $username = shift;

    player_list::remove($username);
    room::removeUser(room::resolve(getLocation($username)), $username);
    file::remove("$ENV{DIR}/data/users/$username/proc");
}

sub create {
    my $username = shift;
    my $password = shift;

    file::print("$ENV{DIR}/data/users/$username/password", $password);
    setLocation($username, "root/spawn");
}

sub getLocation {
    my $username = "@_";
    file::slurp("$ENV{DIR}/data/users/$username/location");
}

sub setLocation {
    my $username = shift;
    my $location = shift;

    file::print("$ENV{DIR}/data/users/$username/location", $location);
}

sub processAlive {
    my $username = shift;
    my $proc_file = "$ENV{DIR}/data/users/$username/proc";

    if (-e $proc_file) {
        return kill(0, file::slurp($proc_file));
    } else {
        return 0;
    }
}

1;