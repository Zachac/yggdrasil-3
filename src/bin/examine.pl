#!/usr/bin/perl

use strict;
use warnings;

use lib::model::user;
use lib::model::items;

shift(@ARGV);

my $name = "@ARGV";
my $location = user::getLocation($ENV{'USERNAME'});

if (items::existsIn($name, $location)) {
    print items::description($name), "\n";
    return;
} elsif (user::existsIn($name, $location)) {
    print "$name is $name\n";
} else {
    print "You can't seem to find the '$name'\n";
}
