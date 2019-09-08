#!/usr/bin/perl
package file;

use strict;
use warnings;

use Fcntl qw(O_NONBLOCK O_WRONLY);
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

    open(my $handle, '>', $filename) or die "Could not open $filename: $!";
    print $handle "@_";
    close $handle;
}

sub printnb {
    die "Not enough arguments!" unless @_ >= 1;
    my $filename = shift;
	my $directory = dirname($filename);

    sysopen(my $fh, $filename, O_NONBLOCK|O_WRONLY) or return 0;
    print $fh "@_";
    close $fh;
}

sub slurp {
    my $filename = "@_";
    local $/;
    open(my $fh, "<", $filename) or die "Could not open $filename: $!";
    return <$fh>;
}

1;