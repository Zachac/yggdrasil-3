
use strict;
use warnings;

use lib::model::client;

my @online_players = client::getAll();
my $player_count = scalar @online_players;

print "Online($player_count): @online_players\n";
