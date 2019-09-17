#!/usr/bin/perl
package room;

use strict;
use warnings;

use File::Spec;
use File::Basename;
use Cwd qw(abs_path);

use lib::io::file;
use environment::db;

INIT {
    $db::conn->do("CREATE TABLE IF NOT EXISTS room (
        location UNIQUE PRIMARY KEY,
        room_name,
        description
    );");

    $db::conn->do("insert or ignore into room(location, room_name, description) values ('root/spawn', 'An empty room', 'It looks like a very normal room.');");
}

sub description {
    my $result = $db::conn->selectrow_array('select description from room where location=?;', undef, shift);
    return $result if (defined($result));
    return "It looks like a normal room";
}

1;
