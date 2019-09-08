#!/usr/bin/perl
package file;

use strict;
use warnings;

use File::Path qw(make_path);
use File::Basename;
use File::Spec;

sub print {
    die "Not enough arguments!" unless @_ >= 1;
    my $filename = shift;
	my $directory = dirname($filename);

    unless ( -d $directory ) {
        make_path($directory) or die "Could not create $directory: $!";
    }

    my $handle;
    open($handle, '>', $filename) or die "Could not open $filename: $!";
    print $handle "@_";
    close $handle;
}

sub slurp {
    my $filename = "@_";
    local $/;
    open(my $fh, "<", $filename) or die "Could not open $filename: $!";
    return <$fh>;
}

1;