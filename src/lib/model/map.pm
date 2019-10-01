#!/usr/bin/perl
package map;

use strict;
use warnings;


sub get(;$$) {
    my @map = ();
    my $offsetX = shift || 0;
    my $offsetY = shift || 0;


    for my $x ($offsetX - 5 .. $offsetX + 5) {
        
        for my $y ($offsetY - 5 .. $offsetY + 5) {
            my $noise = Math::Fractal::Noisemaker::_snoise($x/10, $y/10);
            push @map, $noise > 0? '~' : ' ';
            push @map, ' ';
        }

        push @map, "\n";
    }

    return @map, "\n";
}

1;