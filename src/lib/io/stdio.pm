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
    my $blocking = STDIN->blocking(0);
    my $line = <STDIN>;
    
    STDIN->blocking($blocking);
    return $line;
}

1;