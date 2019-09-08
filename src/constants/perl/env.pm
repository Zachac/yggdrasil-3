#!/usr/bin/perl
package file;

use strict;
use warnings;

use File::Basename;
use Cwd;

my $dir = dirname(Cwd::realpath($0));

if ($dir =~ /(.*\/shell-mud)/) {
    $ENV{"DIR"} = $1;
} else {
    die "Could not find base directory."
}

1;