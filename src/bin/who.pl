
use strict;
use warnings;

use lib::model::user::user;

my @online_players = user::getOnline();
my $player_count = scalar @online_players;

user::echo "Online($player_count): @online_players\n";
