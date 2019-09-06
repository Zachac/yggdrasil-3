#!/usr/bin/perl
use strict;
use warnings;

require "$ENV{DIR}/net/server/tcpsrv.pl";
require "$ENV{DIR}/net/server/tick.pl";

my $port=3329;

if (@ARGV >= 1) {
	$port = $ARGV[0];
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


tcpsrv("localhost:$port", "$ENV{DIR}/net/server/client_handler.sh")
