#!/usr/bin/perl
package map;

use feature qw(switch);

use strict;
use warnings;

srand(0); # init prng before using library
require Math::Fractal::Noisemaker;

my @ascii_table = (' ', '~', '#');
my @name_table = ('Ocean', 'Shore', 'Forest');
my @enterable_table = (0, 1, 1);

sub getCoordinates($;$) {
    my $room = shift;
    my $strict = shift;

    if ($strict) {
        return $room =~ /^d:(-?\d+) (-?\d+)$/;
    } else {
        return $room =~ /^d:(-?\d+) (-?\d+)/;
    }
}

sub getBiome($$) {
    my ($x, $y) = @_;
    my $noise = Math::Fractal::Noisemaker::_snoise($y/10, $x/10);

    if ($noise > 0.005) {
        return 2;
    } elsif ($noise >= 0) {
        return 1;
    } else {
        return 0;
    }
}

sub getBiomeName($) {
    my ($x, $y) = getCoordinates(shift);
    return undef unless defined $x;
    return $name_table[getBiome($x, $y)];
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

sub getDirections($) {
    my ($x, $y) = getCoordinates(shift, 1);
    return () unless defined $x;

    my $n = $enterable_table[getBiome($x - 1, $y)];
    my $s = $enterable_table[getBiome($x + 1, $y)];
    my $e = $enterable_table[getBiome($x, $y + 1)];
    my $w = $enterable_table[getBiome($x, $y - 1)];

    my $ne = $enterable_table[getBiome($x - 1, $y + 1)];
    my $nw = $enterable_table[getBiome($x - 1, $y - 1)];
    my $se = $enterable_table[getBiome($x + 1, $y + 1)];
    my $sw = $enterable_table[getBiome($x + 1, $y - 1)];

    my @directions = ();

    unshift @directions, 'n' if $n;
    unshift @directions, 's' if $s;
    unshift @directions, 'e' if $e;
    unshift @directions, 'w' if $w;

    unshift @directions, 'ne' if ! $n && ! $e && $ne;
    unshift @directions, 'se' if ! $s && ! $e && $se;
    unshift @directions, 'nw' if ! $n && ! $w && $nw;
    unshift @directions, 'sw' if ! $s && ! $w && $sw;

    return @directions;
}

sub getDirection($$) {
    my ($x, $y) = getCoordinates(shift, 1);
    my $direction = shift;

    return undef unless defined $x;

    if ($direction eq 'n') { $x-- }
    elsif ($direction eq 's') { $x++ }
    elsif ($direction eq 'e') { $y++ }
    elsif ($direction eq 'w') { $y-- }
    elsif ($direction eq 'ne') { $x--; $y++ }
    elsif ($direction eq 'se') { $x++; $y++ }
    elsif ($direction eq 'nw') { $x--; $y-- }
    elsif ($direction eq 'sw') { $x++; $y-- }
    else { return undef }
    

    if ($enterable_table[getBiome($x, $y)]) {
        return "d:$x $y";
    }

    return undef;
}

1;