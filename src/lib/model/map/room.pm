#!/usr/bin/perl
package room;

use strict;
use warnings;

use File::Spec;
use File::Basename;
use Cwd qw(abs_path);

use lib::io::file;
use lib::model::map::map;
use lib::env::db;



sub name($) {
    my $room = shift;
    my $result = db::selectrow_array('select room_name from room where location=?;', undef, $room);
    return $result if (defined($result));

    $result = map::getBiomeName($room);
    return $result if (defined($result));

    return "The Void";
}

sub description {
    my $result = db::selectrow_array('select description from room where location=?;', undef, shift);
    return $result if (defined($result));
    return "You see nothing.";
}

sub create($$$) {
    my $location = shift;
    my $room_name = shift;
    my $description = shift;
    return db::do('insert ignore into room(location, room_name, description) values(?,?,?)', undef, $location, $room_name, $description);
}

1;
