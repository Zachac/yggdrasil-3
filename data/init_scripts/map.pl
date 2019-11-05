#!/usr/bin/perl
use strict;
use warnings;

use lib::model::map::biome;


biome::registerByNameAndSymbolAndEnterable('Ocean', ' ', 0);
biome::registerByNameAndSymbolAndEnterable('Forest', '#', 1);
biome::registerByNameAndSymbolAndEnterable('Shore', '~', 1);

1;