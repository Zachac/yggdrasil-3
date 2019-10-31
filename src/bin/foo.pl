#!/usr/bin/perl
package foo;

use strict;
use warnings;

use lib::model::entities::entity_drop;

print "@$_[0]: @$_[1]\n" for entity_drop::getItemNameAndCountsByEntityName("undergrowth");
