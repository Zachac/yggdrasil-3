#!/usr/bin/perl
package commands;

use strict;
use warnings;


sub isValid {
    "@_" =~ "[a-zA-Z0-9 ]*";
}

sub run {
    my $command = shift;
    
    local @ARGV = @_;
    unless (my $return = do "bin/$command.pl") {
        print "Couldn't parse $command: $@\n"      if $@;
        print "Couldn't execute $command: $!\n"    unless defined $return;
    }
}

1;