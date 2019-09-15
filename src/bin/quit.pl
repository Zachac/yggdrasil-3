#!/usr/bin/perl

use strict;
use warnings;

use lib::model::client;


client::remove($ENV{'USERNAME'});

kill -9, getpgrp($$) or die "Could not terminate successfully!";
