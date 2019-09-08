#!/usr/bin/perl
use strict;
use warnings;

use File::Basename;
use Cwd;

use lib dirname(Cwd::realpath($0));

use constants::perl::env;
use lib::net::tcpsrv;
use lib::ticks::tick;


my $port=3329;
my $host='localhost';
my $client_handler=dirname(Cwd::realpath($0)) . "/local_client.pl";

$port = $ARGV[0] if (@ARGV >= 1);
$host = $ARGV[1] if (@ARGV >= 2);
$client_handler = $ARGV[2] if (@ARGV >= 3);


# unless we are the parent, do process ticks
unless (fork) { 
	my $nextime = time;

	do {
		my $thistime = time;

        # tick tick lol
		tick::tick($_) foreach $nextime .. $thistime;

		$nextime = $thistime + 1;
	} while (sleep 1)
}


tcpsrv::tcpsrv("$host:$port", "$client_handler")
