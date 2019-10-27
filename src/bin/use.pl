#!/usr/bin/perl

use strict;
use warnings;

use lib::model::commands::actions;

my $command = shift;

die "usage: $command item name\n" unless @ARGV > 0;

my $item = "@ARGV";
my $result = actions::execute($ENV{'USERNAME'}, $command, $item);

unless ($result) {
    user::echo "Unable to $command $item\n";
}
