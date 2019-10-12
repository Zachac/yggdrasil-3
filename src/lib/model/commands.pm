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
    # add an empty space between user commands
    print "\n";
    
    return runNoNewLine(@_);
}

sub runNoNewLine {
    my $command = $_[0];

    my $location = player::getLocation($ENV{'USERNAME'});
    if ( commands::exists("bin/$command.pl") ) {
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

            if ($@ eq "Interrupted\n") {
                die;
            }
        } elsif (! commands::exists($file)) {
            print "File not found $file\n";
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


my %FILES_FOUND = ();
sub exists {
    my $file = shift;

    return 1 if $FILES_FOUND{$file};

    for (@INC) {
        if (-e "$_/$file") {
            $FILES_FOUND{$file} = 1;
            return 1;
        }
    }

    return 0;
}

1;