#!/usr/bin/perl
package user;

use strict;
use warnings;

use Fcntl qw(:DEFAULT :flock);
use File::Path qw(make_path);

use lib::io::file;
use lib::model::player_list;
use lib::model::room;
use lib::model::client;

use environment::db qw(conn);

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
    

    die "User is already logged in!" unless (my $lock = client::lock($username));
    die "Passwords do not match!" unless ($realPass eq $password);

    $ENV{'USERNAME'}=$username;
    return $lock;
}

sub create {
    my $username = shift;
    my $password = shift;
    return eval {$db::conn->do("insert into user (user_name, password) values (?, ?);", undef, $username, $password)};
}

sub getUsersNearby {
    return @{$db::conn->selectcol_arrayref('select u2.user_name from user u join user u2 on u2.location = u.location where u.user_name=?;', undef, shift)}
}

sub getLocation {
    return $db::conn->selectrow_array('select location from user where user_name = ?', undef, "@_")
}

sub setLocation {
    my $username = shift;
    my $location = shift;
    $db::conn->do('update user set location = ? where user_name=?;', undef, $location, $username);
}

1;