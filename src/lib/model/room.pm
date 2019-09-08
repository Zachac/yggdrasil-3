#!/usr/bin/perl
package room;

use strict;
use warnings;

use File::Spec;
use File::Basename;

use lib::io::file;

sub description {
    return file::slurp("@_/description")
}

sub exists {
    -f "@_/description";
}

sub create {
    file::print("@_/description", "It looks like a normal room.")
}

sub resolve {
    return File::Spec->rel2abs("@_", "$ENV{DIR}/data/rooms/");
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
    file::remove("$room/players/$username")
}

sub getUsers {
    my $room = shift;
    return map { basename $_ } glob("$room/players/*")
}

1;
