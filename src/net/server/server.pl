#!/usr/bin/perl
use strict;
use warnings;

require "$ENV{TCPSRV}";
require "$ENV{TICK}";

my $port=$ENV{SERVER_PORT};
my $host=$ENV{SERVER_HOST};

if (@ARGV >= 1) {
	$port = $ARGV[0];
}

if (@ARGV >= 2) {
	$host = $ARGV[1];
}

# unless we are the parent, do process ticks
unless (fork) { 
	my $nextime = time;

	do {
		my $thistime = time;

		tick($_) foreach $nextime .. $thistime;

		$nextime = $thistime + 1;
	} while (sleep 1)
 }


tcpsrv("$host:$port", "$ENV{CLIENT_HANDLER}")
