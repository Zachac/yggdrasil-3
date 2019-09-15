#!/usr/bin/perl
package user;

use strict;
use warnings;

use Fcntl qw(:DEFAULT :flock);
use File::Path qw(make_path);

use lib::io::file;
use lib::model::player_list;
use lib::model::room;

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
    my $stdout_path = getStdoutPath($username);
    
    return file::printnb($stdout_path, $message);
}

sub stdout {
    my $username = shift;
    my $open_mode = shift;
    my $stdout_path = getStdoutPath($username);

    open(my $stdout, $open_mode, $stdout_path) or die "Could not open $stdout_path!";
    return $stdout;
}

sub getStdoutPath {
    my $fileSafeUsername = quotemeta shift;
    my $stdout_path = "$ENV{DIR}/runtime/clients/$fileSafeUsername.stdout";

    file::initPathTo($stdout_path);
    unless ( -e $stdout_path) {
        system("mkfifo", "$stdout_path");
    }

    return $stdout_path;
}

sub login {
    my $username = shift;
    my $password = shift;
    my $fileSafeUsername = quotemeta $username;
    my $lockFile = "$ENV{DIR}/runtime/users/$fileSafeUsername.lock";
    my $realPass = $db::conn->selectrow_array('select password from user where user_name=?', undef, $username);
    
    open(my $lock, ">", $lockFile) or die "Couldn't open $username lock: $!";
    file::initPathTo($lockFile);

    die "User is already logged in!" unless (flock( $lock, LOCK_EX|LOCK_NB ));
    die "Passwords do not match!" unless ($realPass eq $password);

    $ENV{'USERNAME'}=$username;
    $lock->autoflush(1);
    print $lock $$;
    player_list::add($username);

    return $lock;
}

sub clean {
    die "No user given" unless @_ == 1;
    my $username = shift;
    my $fileSafeUsername = quotemeta $username;
    my $lockFile = "$ENV{DIR}/runtime/users/$fileSafeUsername.lock";

    file::remove($lockFile);
    player_list::remove($username);
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

sub processAlive {
    my $username = quotemeta shift;
    my $proc_file = "$ENV{DIR}/runtime/users/$username.lock";

    if (-e $proc_file) {
        return kill(0, file::slurp($proc_file));
    } else {
        return 0;
    }
}

1;