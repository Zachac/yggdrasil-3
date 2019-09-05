#!/usr/bin/perl
use strict;
use warnings;

require $ENV{DIR}/net/server/tcpsrv


my $port=3329;

if (@ARGV >= 1) {
	$port = $ARGV[0];
}

print "$port\n";

sub test {
	print "$0\n";
	print "@_\n";
	my $x = shift;
	print "$x\n";
}

test @ARGV;


