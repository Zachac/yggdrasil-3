#!/usr/bin/perl
package player_list;

use strict;
use warnings;

use File::Basename;

use lib::io::file;

sub add {
    my $username = quotemeta "@_";
    file::touch("$ENV{DIR}/data/runtime/player_list/$username");
}

sub remove {
    my $username = quotemeta "@_";
    file::remove("$ENV{DIR}/data/runtime/player_list/$username")
}

sub get {
    return map { basename $_ } glob("$ENV{DIR}/data/runtime/player_list/*");
}

1;