#!/usr/bin/perl
package meta_scripts;

use strict;
use warnings;

use lib::model::commands;

sub execute {
    my $script = shift;
    my @commands = split /[;\s]*;[;\s]*/, $script;

    for (@commands) {
        my @args =  split /\s+/, $_;
        my $command = shift @args;
        
        return 0 unless commands::execute("bin/meta_scripts/$command.pl", $command, @args);
    }

    return 1;
}

1;