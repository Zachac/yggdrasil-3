#!/usr/bin/perl

use strict;
use warnings;

use lib::model::commands::actions;

my $command = shift;
my $action = shift;

die "usage: $command $action item name\n" unless @ARGV > 0;

my $item = "@ARGV";
my $result = actions::execute($ENV{'USERNAME'}, $action, $item);

unless ($result) {
    user::echo "Unable to $action $item\n";
}
