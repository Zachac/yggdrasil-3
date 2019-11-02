#!/usr/bin/perl

use strict;
use warnings;

use Scalar::Util qw(looks_like_number);
use Lingua::EN::Inflexion qw( inflect );

use lib::model::user::user;
use lib::model::user::inventory;
use lib::io::format;

my $command = shift;
my $count;

$count = shift if (looks_like_number $ARGV[0]);

unless (@ARGV > 0 || (defined $count && $count < 1)) {
    user::echo "usage: $command take item name\n";
    return 1;
}

my $item_name = "@ARGV";
my $count_taken = inventory::take($ENV{'USERNAME'}, "$item_name", undef, $count);

if ($count_taken) {
    if ($count_taken == 1) {
        my $withArticle = format::withArticle($item_name);
        user::broadcastAction($ENV{'USERNAME'}, "took $withArticle.");
    } else {
        user::broadcastAction($ENV{'USERNAME'}, inflect "took <#w:$count_taken> <N:$item_name>");
    }
} else {
    user::echo "You can't seem to find the $item_name\n";
}
