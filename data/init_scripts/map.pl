#!/usr/bin/perl
use strict;
use warnings;
use English qw(-no_match_vars);

use lib::model::map::biome;
use lib::io::stdio;

stdio::log("running $PROGRAM_NAME");

biome::registerByNameAndSymbolAndEnterable('Ocean', ' ', 0);
biome::registerByNameAndSymbolAndEnterable('Forest', '#', 1);
biome::registerByNameAndSymbolAndEnterable('Shore', '~', 1);

1;