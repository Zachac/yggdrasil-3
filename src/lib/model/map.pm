#!/usr/bin/perl
package map;

use strict;
use warnings;

srand(0); # init prng before using library
require Math::Fractal::Noisemaker;

my @ascii_table = (' ', '~', '#');
my @name_table = ('Ocean', 'Shore', 'Forest');

sub getBiome($$) {
    my ($x, $y) = @_;
    my $noise = Math::Fractal::Noisemaker::_snoise($y/10, $x/10);

    if ($noise > 0.005) {
        return 2;
    } elsif ($noise > 0) {
        return 1;
    } else {
        return 0;
    }
}

sub getBiomeName($$) {
    return $name_table[getBiome(shift, shift)];
}

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
            push @map, $ascii_table[getBiome($x, $y)];
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