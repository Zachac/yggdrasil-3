#!/usr/bin/perl
package user;

use strict;
use warnings;

use Fcntl qw(:DEFAULT :flock);
use File::Path qw(make_path);

use lib::io::file;
use lib::model::room;
use lib::model::client;
use lib::model::player;

use environment::db qw(conn);

INIT {
    $db::conn->do("CREATE TABLE IF NOT EXISTS user (
        user_name NOT NULL PRIMARY KEY,
        password NOT NULL,
        pid
    );");
}

sub lock;

sub isValidUsername {
    "@_" =~ m/^[a-zA-Z0-9]{3,}$/
}

sub exists {
    return 0 != $db::conn->selectrow_array("select count(1) from user where user_name=?;", undef, "@_");
}

sub tellFrom {
    my $username = shift;
    my $source = shift;
    my $message = "$source: @_";
    return client::message($username, $message);
}

sub login {
    my $username = shift;
    my $password = shift;
    my $realPass = $db::conn->selectrow_array('select password from user where user_name=?', undef, $username);
    
    die "User is already logged in!\n" unless lock $username;
    die "Passwords do not match!\n" unless ($realPass eq $password);

    $ENV{'USERNAME'}=$username;
    return 1;
}

sub pid {
    my $username = shift;
    $db::conn->selectrow_array('select pid from user where user_name=?', undef, $username);
}

sub pidAlive {
    my $lock_pid = pid shift;
    return 0 unless defined $lock_pid;
    return kill(0, $lock_pid);
}

sub lock {
    my $username = shift;
    my $pid = $$;
    return 0 != $db::conn->do('update user set pid=? where user_name=? and (pid is null or pid < 0)', undef, $pid, $username);
}

sub unlock {
    my $username = shift;
    return 0 != $db::conn->do('update user set pid=NULL where user_name=?', undef, $username);
}

sub create {
    my $username = shift;
    my $password = shift;
    player::setLocation($username, 'root/spawn');
    return eval {$db::conn->do("insert into user (user_name, password) values (?, ?);", undef, $username, $password)};
}

sub getOnline {
    return @{$db::conn->selectcol_arrayref('select user_name from user where pid is not null and pid >= 0')};
}

1;