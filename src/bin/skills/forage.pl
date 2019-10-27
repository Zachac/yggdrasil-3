#!/usr/bin/perl

use strict;
use warnings;

use lib::model::entities::resource;
use lib::model::user::user;

my $command = shift;

unless (@ARGV > 0) {
    user::echo "usage: $command resource name\n";
    return;
}

if (skills::randomFailure($command, $ENV{'USERNAME'})) {
    user::echo "you fail to produce anything of value this time\n";
    return;
}

my $result = resource::gather($ENV{'USERNAME'}, $command, "@ARGV");

if (defined $result) {
    skills::addExp($ENV{'USERNAME'}, $command, 1);
    user::echo "You find some $result.\n";
} else {
    user::echo "You find nothing.\n";
}
