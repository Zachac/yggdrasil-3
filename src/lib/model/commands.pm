#!/usr/bin/perl
package commands;

use strict;
use warnings;

use lib::model::room;
use lib::model::links;
use lib::model::entities::entity;
use lib::model::skills;
use lib::model::entities::player;

use lib::model::meta_scripts;

sub isValid {
    "@_" =~ "[a-zA-Z0-9 ]*";
}

sub runCommand {
    my $command = $_[0];
    execute("bin/$command.pl", @_);
}

sub run {
    my $command = $_[0];

    # add an empty space between user commands
    print "\n";
    my $location = player::getLocation($ENV{'USERNAME'});
    if ( commands::exists($command) ) {
        runCommand @_;
    } elsif (skills::exists($command)) {
        skills::execute(@_);
    } elsif (my $dest = links::getExit($location, "@_")) {
        meta_scripts::execute("jump", $dest);
    } else {
        print "Command not found!\n";
    }

}

sub execute {
    my $file = shift;
    local @ARGV = @_;
    my $result = do $file;

    unless (defined($result)) {
        if (defined $@ && $@ ne '') {
            print "$@";
        } else {
            print "Unable to execute $file\n";
        }
    }

    return $result;
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