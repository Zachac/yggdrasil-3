#!/usr/bin/perl
package recipe;

use strict;
use warnings;

use lib::env::db qw(conn);
use lib::model::user::inventory;
use lib::model::user::skills;


sub registerRecipe($$$$) {
    my $item_name = shift;
    my $skill_name = shift;
    my $required_level = shift;
    my $experience = shift;
    return db::do('insert into recipe(item_name, skill_name, required_level, experience) values (?, ?, ?, ?)', undef, $item_name, $skill_name, $required_level, $experience);
}

sub registerRecipeRequirement($$$) {
    my $item_name = shift;
    my $required_name = shift;
    my $count = shift;
    return db::do('insert into recipe_requirements(item_name, required_name, count) values (?, ?, ?)', undef, $item_name, $required_name, $count);
}

sub exists($) {
    my $item_name = shift;
    return 0 != db::selectrow_array('select count(1) from recipe where item_name = ?', undef, $item_name);
}

sub requirements($;@) {
    my $item_name = shift;
    my @required_items = @_;
    
    unless (@required_items) {
        @required_items = @{db::selectall_arrayref('select required_name, count from recipe_requirements where item_name = ?', undef, $item_name)};
    }
    return map { "@$_[0] x@$_[1]" } @required_items;
}

sub getLevelByItemName($) {
    my $item_name = shift;
    return db::selectrow_array('select skill_name, required_level from recipe where item_name = ?', undef, $item_name);
}

sub getExpByItemName($) {
    my $item_name = shift;
    return db::selectrow_array('select skill_name, experience from recipe where item_name = ?', undef, $item_name);
}

1;