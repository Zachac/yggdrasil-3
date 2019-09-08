#!/usr/bin/perl

use strict;
use warnings;

require lib::model::room;

if (room::exists(".")) {
    print room::description("."), "\n";
} else {
    print "You don't see anything in particular.\n";
}
