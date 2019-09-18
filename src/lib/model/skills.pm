#!/usr/bin/perl
package skills;

use strict;
use warnings;

use lib::model::commands;
use environment::db;

INIT {
    $db::conn->do("CREATE TABLE IF NOT EXISTS skills (
        user_name,
        skill_name,
        experience,
        level
    );");
}

sub exists {
    my $skill = shift;

    for (@INC) {
        return 1 if (-e "$_/bin/skills/$skill.pl");
    }

    return 0;
}

sub execute {
    my $skill = shift;
    commands::execute("bin/skills/$skill.pl", @_);
}

sub require {
    my $skill = shift;
    my $level = shift;

    return 1 if ($db::conn->selectrow_array("select 1 from skills where user_name = ? and skill_name = ? and level >= ?", undef, $ENV{'USERNAME'}, $skill, $level));

    print "Level $level $skill required\n";
    return 0;
}

sub getAll {
    return @{$db::conn->selectall_arrayref("select skill_name, level, experience from skills where user_name = ?", undef, $ENV{'USERNAME'})};
}

sub get {
    my $skill = shift;
    my ($level, $experience) = $db::conn->selectrow_array("select level, experience from skills where user_name = ? and skill_name = ?", undef, $ENV{'USERNAME'}, $skill);
    $level = 0 unless defined $level;
    $experience = 0 unless defined $experience;
    return ($level, $experience);
}

sub requiredExp {
    my $level = shift;

    return 0 if $level == 0;
    return undef if $level >= 10;
    return 10 ** $level;
}

sub train {
    my $skill = shift;

    die "skill $skill does not exist\n" unless skills::exists $skill;

    my ($level, $experience) = skills::get $skill;
    my $requiredExp = requiredExp $level;

    die "max level already reached\n" unless defined $requiredExp;
    die "total level cap already reached\n" unless totalLevel() < 100;
    die "not enough experience to train another level\n" if $requiredExp > $experience;
    $db::conn->do('insert or replace into skills (user_name, skill_name, level, experience) values (?, ?, ?, ?)', undef, $ENV{'USERNAME'}, $skill, $level + 1, $experience - $requiredExp) or die;
}

sub totalLevel {
    return $db::conn->selectrow_array('select sum(level) from skills where user_name = ?', undef, $ENV{'USERNAME'});
}

1;