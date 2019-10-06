#!/usr/bin/perl
package meta_scripts;

use strict;
use warnings;

use lib::model::commands;

sub execute {
    my $script = shift;
    commands::execute("bin/meta_scripts/$script.pl", $script, @_);
}

1;