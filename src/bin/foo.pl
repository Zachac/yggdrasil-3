#!/usr/bin/perl
package foo;

use strict;
use warnings;

use lib::model::entities::entity_drop;

entity_drop::getItemDefIdAndCountsByEntityName("undergrowth");
