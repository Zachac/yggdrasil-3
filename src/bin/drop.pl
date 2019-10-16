#!/usr/bin/perl

use strict;
use warnings;

use Scalar::Util qw(looks_like_number);
use Lingua::EN::Inflexion qw( inflect );

use lib::model::inventory;
use lib::model::user;
use lib::io::format;

my $command = shift;
my $count;

$count = shift if (looks_like_number $ARGV[0]);

unless (@ARGV > 0 || (defined $count && $count < 1)) {
    print "usage: $command [count] item name\n";
    return 1;
}

my $item_name = "@ARGV";
my $count_dropped = inventory::drop($ENV{'USERNAME'}, $item_name, undef, $count);

if ($count_dropped) {
    if ($count_dropped == 1) {
        my $withArticle = format::withArticle($item_name);
        user::broadcastOthers($ENV{'USERNAME'}, "$ENV{'USERNAME'} drops $withArticle");
        print "You drop $withArticle\n";
    } else {
        user::broadcastOthers($ENV{'USERNAME'}, inflect "$ENV{'USERNAME'} drops <#w:$count_dropped> <N:$item_name>");
        print inflect "You drop <#w:$count_dropped> <N:$item_name>\n";
    }
} else {
    print "You can't seem to find the $item_name in your inventory\n";
}
