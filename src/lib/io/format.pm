#!/usr/bin/perl
package format;

use strict;
use warnings;


sub asCount($$) {
    my ($item, $count) = @_;

    if ($count <= 1) {
        return $item;
    } else {
        return "$item x$count";
    }
}

sub getCounts {
    return () if @_ <= 0;

    @_ = sort @_;
    
    my @result = ();
    my $count = 0;
    my $lastValue = $_[0];

    for (@_) {
        if ($lastValue eq $_) {
            $count++;
        } else {
            push @result, asCount($lastValue, $count);
            $lastValue = $_;
            $count = 1;
        }
    }

    push @result, asCount($lastValue, $count);

    return @result;
}

1;