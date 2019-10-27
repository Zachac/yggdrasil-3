#!/usr/bin/perl

use strict;
use warnings;

use lib::model::commands::commands;
use lib::model::user::user;
use lib::io::stdio;

use Time::HiRes qw(sleep);
use Scalar::Util qw(looks_like_number);

my $command = shift;
my $count = shift;

die "usage: $command count [command]\n" unless looks_like_number $count;

user::echo "press enter to interrupt\n";

while ($count > 0 && ! defined stdio::readLineNB()) {
    $count--;

    if (@ARGV > 0) {
        commands::runNoNewLine(@ARGV);
    }

    sleep 0.4;
}

user::echo "finished repeat\n";
