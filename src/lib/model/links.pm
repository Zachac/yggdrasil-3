#!/usr/bin/perl
package links;

use strict;
use warnings;

use File::Spec;
use File::Basename;
use Cwd qw(abs_path);

use lib::io::file;
use lib::model::map;
use environment::db;

INIT {
    $db::conn->do("CREATE TABLE IF NOT EXISTS links (
        link_name,
        src_location,
        dest_location
    );");
}

sub add {
    my $room = shift;
    my $another_room = shift;
    my $name = shift;
    $db::conn->do('insert into links (link_name, src_location, dest_location) values (?, ?, ?);', undef, $name, $room, $another_room);
}

sub remove {
    my $room = shift;
    my $name = shift;
    $db::conn->do('delete from links where src_location=? and link_name=?;', undef, $room,  $name);
}

sub getExits {
    my $room = shift;
    
    my @exits = @{$db::conn->selectcol_arrayref('select l.link_name from links l where l.src_location = ?;', undef, $room)};
    push(@exits, map::getDirections($room));

    return @exits;
}

sub getExit {
    my $room = shift;
    my $name = shift;
    my $exit = $db::conn->selectrow_array('select dest_location from links where src_location=? and link_name=?;', undef, $room,  $name);
    $exit = map::getDirection($room, $name) unless $exit;
    return $exit;
}

1;