#!/usr/bin/perl
package commands;

use strict;
use warnings;

use lib::model::room;

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
    } elsif (room::getExitExists(".", $line)) {
        run("jump", room::getExitRelative(".", $line));
    } else {
        print "Command not found!\n";
    }
 
}

sub exists {
    my $command = shift;

    for (@INC) {
        return 1 if (-e "$_/bin/$command.pl");
    }

    return 0;
}

1;