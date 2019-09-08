#!/usr/bin/perl

use strict;
use warnings;

use Cwd;

require lib::model::room;

my $forced_jump;

# extract and remove -f forced_jump flag;
@ARGV = grep { ! ($forced_jump = 1) unless !/^-f$/ } @ARGV;

my $path = "@ARGV";


if (room::isValidRoomPath($path)) {
    my $abs_path = room::resolve(@ARGV);

    if ($forced_jump && ! room::exists($abs_path)) {
        print "Creating room!\n";
        room::create($abs_path);
    }

    if (room::exists($abs_path)) {
        chdir($abs_path) or die "Could not enter room!";
    } else {
        print "This room does not exist! ", $path, "\n";
    }
} else {
    print "Invalid room location: $path\n";
}


