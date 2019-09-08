#!/usr/bin/perl
package room;

use strict;
use warnings;

use File::Spec;

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

1;
