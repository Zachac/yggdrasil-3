#!/usr/bin/perl

use strict;
use warnings;

use lib::model::inventory;

my $command = shift;
my $count;

$count = shift if (looks_like_number $ARGV[0]);

unless (@ARGV > 0 || (defined $count && $count < 1)) {
    print "usage: $command take item name\n";
    return 1;
}

my $item_name = "@ARGV";
my $count_taken = inventory::take($ENV{'USERNAME'}, "$item_name", undef, $count);

if ($count_taken) {
    if ($count_taken == 1) {
        my $withArticle = format::withArticle($item_name);
        user::broadcastOthers($ENV{'USERNAME'}, inflect "$ENV{'USERNAME'} takes $withArticle");
        print "You take $withArticle\n";
    } else {
        user::broadcastOthers($ENV{'USERNAME'}, inflect "$ENV{'USERNAME'} takes <#w:$count_taken> <N:$item_name>");
        print inflect "You take <#w:$count_taken> <N:$item_name>\n";
    }
} else {
    print "You can't seem to find the $item_name\n";
}
