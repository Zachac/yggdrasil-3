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
    return $db::conn->selectrow_array('select description from description where description_id=(select description_id from room where room_name=?);', undef, "@_");
}

sub exists {
    return $db::conn->selectrow_array('select count(1) from room where room_name=?;', undef, "@_");
}

sub create {
    $db::conn->do('insert or ignore into room(room_name) values(?)', undef, "@_");
}

sub addExit {
    my $room = shift;
    my $another_room = shift;
    my $name = shift;

    $db::conn->do('insert or ignore into links (link_name, src_room_id, dest_room_id) values (
        ?,
	    (select room_id from room where room_name=?),
	    (select room_id from room where room_name=?)
    );', undef, $name, $room, $another_room)
}

sub removeExit {
    my $room = shift;
    my $name = shift;
    
    $db::conn->do('delete from links where src_room_id=(select room_id from room where room_name=?) and link_name=?;', undef, $room,  $name)
}

sub getExits {
    return @{$db::conn->selectcol_arrayref('select l.link_name from room r join links l on l.src_room_id = r.room_id where r.room_name = ?;', undef, shift)}
}

sub getExit {
    my $room = shift;
    my $name = shift;

    return $db::conn->selectrow_array('
    select r.room_name from links
    join room r on r.room_id = dest_room_id 
    where src_room_id=(select room_id from room where room_name=?) 
    and link_name=?;', undef, $room,  $name)
}

1;
