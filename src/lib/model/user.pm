#!/usr/bin/perl
package user;

use strict;
use warnings;

use Fcntl qw(:DEFAULT :flock);
use File::Path qw(make_path);

use lib::io::file;
use lib::model::room;
use lib::model::client;
use lib::model::entities::player;

use environment::db qw(conn);

$db::conn->do("CREATE TABLE IF NOT EXISTS user (
    user_name NOT NULL PRIMARY KEY,
    password NOT NULL,
    spawn NOT NULL DEFAULT 'd:0 0',
    pid
);");

sub lock;

sub isValidUsername {
    "@_" =~ m/^[a-zA-Z0-9]{3,}$/
}

sub exists {
    return 0 != $db::conn->selectrow_array("select count(1) from user where user_name=?;", undef, "@_");
}

sub tell {
    return client::message(@_);
}

sub broadcast($$) {
    my $username = shift;
    my $message = shift;
    my $location = player::getLocation($username);
    client::message($_, $message) for player::getAll($location);
}

sub broadcastOthers($$) {
    my $username = shift;
    my $message = shift;
    my $location = player::getLocation($username);
    for (player::getAll($location)) {
        client::message($_, $message) unless $_ eq $username;
    }
}

sub login {
    my $username = shift;
    my $password = shift;
    my $realPass = $db::conn->selectrow_array('select password from user where user_name=?', undef, $username);
    
    die "Passwords do not match!\n" unless ($realPass eq $password);
    die "User is already logged in!\n" unless lock $username;

    $ENV{'USERNAME'}=$username;
    return 1;
}

sub pid {
    my $username = shift;
    return $db::conn->selectrow_array('select pid from user where user_name=?', undef, $username);
}

sub pidAlive {
    my $lock_pid = pid shift;
    return 0 unless defined $lock_pid && $lock_pid >= 0;
    return kill(0, $lock_pid);
}

sub lock {
    my $username = shift;
    my $pid = $$;

    return 0 if pidAlive $username;
    return 0 if 0 == $db::conn->do('update user set pid=? where user_name=?', undef, $pid, $username);
    return $pid == pid $username;
}

sub unlock {
    my $username = shift;
    return 0 != $db::conn->do('update user set pid=NULL where user_name=?', undef, $username);
}

sub create {
    my $username = shift;
    my $password = shift;

    return unless eval {$db::conn->do("insert into user (user_name, password) values (?, ?);", undef, $username, $password)};
    spawn($username);
    return 1;
}

sub getSpawn($) {
    my $username = shift;
    return $db::conn->selectrow_array('select spawn from user where user_name = ?', undef, $username);
}

sub spawn($;$) {
    my $username = shift;
    my $spawn = shift // getSpawn $username;
    player::setLocation $username, $spawn;
}

sub getOnline {
    return @{$db::conn->selectcol_arrayref('select user_name from user where pid is not null and pid >= 0')};
}

1;