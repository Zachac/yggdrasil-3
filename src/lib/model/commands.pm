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
        local @ARGV = @_;
        unless (my $return = do "bin/$command.pl") {
            print "Couldn't parse $command: $@\n"      if $@;
            print "Couldn't execute $command: $!\n"    unless defined $return;
        }
    } elsif (my $dest = room::getExit(user::getLocation($ENV{USERNAME}), $line)) {
        run("jump", $dest);
    } else {
        print "Command not found!\n";
    }
 
}

sub runAs {
    my $currentUser = $ENV{'USER'};
    $ENV{'USER'} = shift;
    run(@_);
    $ENV{'USER'} = $currentUser;
}

sub exists {
    my $command = shift;

    for (@INC) {
        return 1 if (-e "$_/bin/$command.pl");
    }

    return 0;
}

1;