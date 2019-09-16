#!/usr/bin/perl
package skills;

use strict;
use warnings;

use lib::model::commands;

sub exists {
    my $skill = shift;

    for (@INC) {
        return 1 if (-e "$_/bin/skills/$skill.pl");
    }

    return 0;
}

sub execute {
    my $skill = shift;
    commands::execute("bin/skills/$skill.pl", @_);
}

1;