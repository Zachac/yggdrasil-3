#!/usr/bin/perl
use strict;
use warnings;

use lib::model::map::biome;


biome::registerByNameAndSymbolAndEnterable('Ocean', ' ', 0) or die "Unable to register biome\n";
biome::registerByNameAndSymbolAndEnterable('Forest', '#', 1) or die "Unable to register biome\n";
biome::registerByNameAndSymbolAndEnterable('Shore', '~', 1) or die "Unable to register biome\n";

1;