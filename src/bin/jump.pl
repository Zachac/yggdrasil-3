#!/usr/bin/perl

use strict;
use warnings;

use Cwd;

require lib::model::room;
require lib::model::commands;

my $forced_jump;

# extract and remove -f forced_jump flag;
@ARGV = grep { ! ($forced_jump = 1) unless !/^-f$/ } @ARGV;

my $path = "@ARGV";

$path = user::getLocation($ENV{'USERNAME'}) if ($path =~ /^\s*$/);

if (room::isValidRoomPath($path)) {
    my $abs_path = room::resolve($path);

    if ($forced_jump && ! room::exists($abs_path)) {
        print "Creating room!\n";
        room::create($abs_path);
    }

    if (room::exists($abs_path)) {
        room::removeUser(Cwd::cwd(), $ENV{'USERNAME'});
        chdir($abs_path) or die "Could not enter room!";
        user::setLocation($ENV{'USERNAME'}, $path);
        room::addUser($abs_path, $ENV{'USERNAME'});
        commands::run("look");
    } else {
        print "This room does not exist! ", $path, "\n";
    }
} else {
    print "Invalid room location: $path\n";
}


