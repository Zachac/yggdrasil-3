#!/usr/bin/perl

use strict;
use warnings;

use Cwd;

use lib::model::room;
use lib::model::commands;

my $forced_jump;

# extract and remove -f forced_jump flag;
@ARGV = grep { ! ($forced_jump = 1) unless !/^-f$/ } @ARGV;

# get path from args or if empty, use the current user location
my $path = "@ARGV";
$path = user::getLocation($ENV{'USERNAME'}) if ($path =~ /^\s*$/);

if ($forced_jump && ! room::exists($path)) {
    print "Creating room!\n";
    room::create($path);
}

if (room::exists($path)) {
    user::setLocation($ENV{'USERNAME'}, $path);
    commands::run("look");
} else {
    print "This room does not exist! ", $path, "\n";
}


