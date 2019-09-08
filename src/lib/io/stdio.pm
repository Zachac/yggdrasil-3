#!/usr/bin/perl
package stdio;

use strict;
use warnings;

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

1;