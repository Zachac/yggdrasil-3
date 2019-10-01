#!/usr/bin/perl
package env;

use strict;
use warnings;

use File::Basename;
use Cwd;

BEGIN {
    srand(0);
}

my $dir = dirname(Cwd::realpath($0));

if ($dir =~ /(.*\/yggdrasil-3)/) {
    $ENV{"DIR"} = $1;
} else {
    die "Could not find base directory.";
}

1;