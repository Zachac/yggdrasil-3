
use strict;
use warnings;

use lib::model::user;
use lib::model::player_list;

my @online_players = player_list::get();
my $player_count = scalar @online_players;

print "Online($player_count): @online_players\n";
