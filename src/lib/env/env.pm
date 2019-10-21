#!/usr/bin/perl
package env;

use strict;
use warnings;

use English qw(-no_match_vars);
use File::Basename;
use Cwd;

my $full_dir = dirname(Cwd::realpath($PROGRAM_NAME));
my $dir;

if ($full_dir =~ /(.*\/yggdrasil-3)/xms) {
    $dir = $1;
} else {
    die "Could not find base directory of yggdrasil installation.\n";
}

sub dir() {
    return $dir;
}

1;
