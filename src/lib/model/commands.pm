#!/usr/bin/perl
package commands;

use strict;
use warnings;

use lib::model::room;
use lib::model::links;
use lib::model::user;
use lib::model::skills;

sub isValid {
    "@_" =~ "[a-zA-Z0-9 ]*";
}

sub runCommand {
    my $command = shift;
    execute("bin/$command.pl", @_);
}

sub run {
    my $command = $_[0];

    # add an empty space between user commands
    print "\n";

    if ( commands::exists($command) ) {
        runCommand $command, @_;
    } elsif (skills::exists($command)) {
        skills::execute($command);
    } elsif (my $dest = links::getExit(user::getLocation($ENV{'USERNAME'}), "@_")) {
        run("jump", $dest);
    } else {
        print "Command not found!\n";
    }

}

sub execute {
    my $file = shift;
    local @ARGV = @_;
    
    unless (defined(do $file)) {
        print "$@";
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