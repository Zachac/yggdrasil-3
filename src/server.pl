#!/usr/bin/perl
use strict;
use warnings;

use File::Basename;

use lib dirname("$0");

use net::server::tcpsrv;

# require "$ENV{TCPSRV}";
# require "$ENV{TICK}";

my $port=3329;
my $host='localhost';
my $client_handler=dirname("$0") . "/local_client.pl";

$port = $ARGV[0] if (@ARGV >= 1);
$host = $ARGV[1] if (@ARGV >= 2);
$client_handler = $ARGV[2] if (@ARGV >= 3);


# unless we are the parent, do process ticks
# unless (fork) { 
# 	my $nextime = time;

# 	do {
# 		my $thistime = time;

# 		tick($_) foreach $nextime .. $thistime;

# 		$nextime = $thistime + 1;
# 	} while (sleep 1)
#  }


tcpsrv::tcpsrv("$host:$port", "$client_handler")
