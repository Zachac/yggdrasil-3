#!/usr/bin/perl

use strict;
use warnings;

use lib::model::room;
use lib::model::links;
use lib::model::entities::entity;
use lib::model::entities::player;

use Lingua::EN::Inflexion qw(noun inflect);

commands::runCommand("map", 2);

my $room = player::getLocation($ENV{'USERNAME'});
print room::name($room), "\n";
print room::description($room), "\n";

my @exits = links::getExits($room);
@exits = ("none") unless (@exits > 0);
print "  Obvious exits: @exits\n";

my $ents = entity::getAllEx($room);

if (@$ents > 0) {
    print "  You can see:\n";
    for (@$ents) {
        if (player::isPlayer(@$_[1])) {
            print "    @$_[0]\n" 
        } else {
            my $noun = noun(@$_[0]);
            my $article;

            if ($noun->is_singular()) {
                $article = $noun->indef_article();
            } else {
                $article = "the";
            }

            print "    $article @$_[0]\n" 
        }
    }
}
