#!/usr/bin/perl
package room;

use strict;
use warnings;

use File::Spec;
use File::Basename;
use Cwd qw(abs_path);

use lib::io::file;

sub description {
    return file::slurp("@_/description")
}

sub exists {
    -f "@_/description";
}

sub create {
    my $relPath = resolveRelative(@_);
    $db::conn->do('insert or ignore into room(room_name) values(?)', undef, $relPath);
    file::print("@_/description", "It looks like a normal room.")
}

# resolve the relative path from absolute
sub resolve {
    return File::Spec->rel2abs("@_", "$ENV{DIR}/data/rooms/");
}

# resolve the relative path from absolute path
sub resolveRelative {
    return File::Spec->abs2rel("@_", "$ENV{DIR}/data/rooms/");
}

sub isValidRoomPath {
    "@_" =~ /^\w+(\/\w+)*\/?$/;
}

sub addUser {
    my $room = shift;
    my $username = quotemeta shift;
    file::touch("$room/players/$username")
}

sub removeUser {
    my $room = shift;
    my $username = quotemeta shift;
    file::remove("$room/players/$username");
}

sub getUsers {
    return map { basename $_ } glob(shift() . "/players/*");
}

sub addExit {
    my $room = shift;
    my $another_room = shift;
    my $name = quotemeta shift;

    file::symlink($another_room, "$room/exits/$name");
}

sub removeExit {
    my $room = shift;
    my $exit = quotemeta shift;
    file::remove("$room/exits/$exit");
}

sub getExits {
    return map { basename $_ } glob(shift() . "/exits/*")
}

sub getExitExists {
    my $room = shift;
    my $exit_name = shift;

    -l "$room/exits/$exit_name";
}

sub getExitRelative {
    my $room = shift;
    my $exit_name = shift;

    my $exit = abs_path("$room/exits/$exit_name");

    return resolveRelative $exit;
}

1;
