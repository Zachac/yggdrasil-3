#!/usr/bin/perl
package actions;

use strict;
use warnings;

use lib::model::entities::entity;
use lib::model::entities::player;
use lib::model::user::inventory;

use lib::model::commands::meta_scripts;


sub set($$$;$) {
    my $item_name = shift;
    my $action = shift;
    my $script = shift;
    my $consume = shift // 0;
    db::do('replace into actions(item_name, action, script, consume) values(?,?,?,?)', undef, $item_name, $action, $script, $consume);
}

sub execute($$$) {
    my $player = shift;
    my $action = shift;
    my $item_name = shift;

    my $item_id = inventory::find($player, $item_name); 

    unless (defined $item_id) {
        my $location = player::getLocation($player);
        $item_id = item::find($item_name, $location);

        die "Could not find $item_name\n" unless defined $item_id;
    }

    my ($script, $consume) = db::selectrow_array('select script, consume from actions where item_name = ? and action = ?', undef, $item_name, $action);

    die "Nothing interesting happens\n" unless defined $script;

    my $result = meta_scripts::execute($script);

    print "'$result' '$consume' '$item_id'\n";

    if ($result && $consume) {
        item::deleteById($item_id);
    }

    return $result;
}

1;