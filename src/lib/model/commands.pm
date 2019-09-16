#!/usr/bin/perl
package commands;

use strict;
use warnings;

use lib::model::room;
use lib::model::user;

sub isValid {
    "@_" =~ "[a-zA-Z0-9 ]*";
}

sub run {
    my $line = "@_";
    my $command = shift;

    if ( commands::exists($command) ) {
        execute("bin/$command.pl");
    } elsif (my $dest = room::getExit(user::getLocation($ENV{USERNAME}), $line)) {
        run("jump", $dest);
    } else {
        print "Command not found!\n";
    }
 
}

sub execute {
    my $file = shift;
    local @ARGV = @_;
    unless (my $return = do $file) {
        print "Couldn't parse $file: $@\n"      if $@;
        print "Couldn't execute $file: $!\n"    unless defined $return;
    }
}

sub runAs {
    my $currentUser = $ENV{'USERNAME'};
    $ENV{'USERNAME'} = shift;
    run(@_);
    $ENV{'USERNAME'} = $currentUser;
}

sub exists {
    my $command = shift;

    for (@INC) {
        return 1 if (-e "$_/bin/$command.pl");
    }

    return 0;
}

1;