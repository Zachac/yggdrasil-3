#!/usr/bin/perl
package room;

use strict;
use warnings;

use File::Spec;
use File::Basename;
use Cwd qw(abs_path);

use lib::io::file;
use environment::db;

sub description {
    my $result = $db::conn->selectrow_array('select description from room where location=?;', undef, shift);
    return $result if (defined($result));
    return "It looks like a normal room";
}

sub addExit {
    my $room = shift;
    my $another_room = shift;
    my $name = shift;
    $db::conn->do('insert or ignore into links (link_name, src_location, dest_location) values (?, ?, ?);', undef, $name, $room, $another_room);
}

sub removeExit {
    my $room = shift;
    my $name = shift;
    $db::conn->do('delete from links where src_location=? and link_name=?;', undef, $room,  $name);
}

sub getExits {
    return @{$db::conn->selectcol_arrayref('select l.link_name from links l where l.src_location = ?;', undef, shift)}
}

sub getExit {
    my $room = shift;
    my $name = shift;
    return $db::conn->selectrow_array('select dest_location from links where src_location=? and link_name=?;', undef, $room,  $name)
}

1;
