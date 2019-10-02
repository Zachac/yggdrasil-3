#!/usr/bin/perl
package map;

use strict;
use warnings;


sub get(;$$$) {
    my @map = ();
    my $offsetX = shift || 0;
    my $offsetY = shift || 0;
    my $r = shift;

    unless (defined $r && $r > 0) {
        $r = 5;
    }

    for my $x ($offsetX - $r .. $offsetX + $r) {
        
        for my $y ($offsetY - $r .. $offsetY + $r) {
            my $noise = Math::Fractal::Noisemaker::_snoise($x/10, $y/10);

            if ($noise > 0.005) {
                push @map, '#';
            } elsif ($noise > 0) {
                push @map, '~';
            } else {
                push @map, ' ';
            }

            push @map, ' ';
        }

        push @map, "\n";
    }

    my $middle = $#map/2;
    $map[$middle] = '<';
    $map[$middle - 2] = '>';

    return @map, "\n";
}

1;