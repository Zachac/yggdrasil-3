#!/usr/bin/perl
package stdio;

use strict;
use warnings;

use IO::Handle;

sub readLine {
    my $line = <STDIN> || die "Disconnected";
    chomp($line);
    return $line;
}

sub readArgs {
    return split(/\s+/, readLine());
}

sub prompt {
    print "@_\n";
    return readLine;
}

sub readLineNB {
    # disable the blocking value temporarily and store the 
    # value so we can return it to the original state
    my $fh = shift // \*STDIN;
    my $blocking = $fh->blocking(0);
    my $line = <$fh>;
    
    $fh->blocking($blocking);
    return $line;
}

sub setStdout($) {
    my $fh = shift;
    *STDOUT = $fh;
}

sub setStderr($) {
    my $fh = shift;
    *STDERR = $fh;
}

sub log {
    my $line = "@_";
    $line =~ s/\n?$/\n/;
    print scalar localtime() . " $line";
}

1;