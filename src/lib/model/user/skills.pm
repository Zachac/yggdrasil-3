#!/usr/bin/perl
package skills;

use strict;
use warnings;

use lib::model::commands::commands;
use lib::io::format;
use lib::env::db;

my $max_level = 10;
my @failure_table = (0.05, 0.05, 0.1, 0.2, 0.4, 0.6, 0.75, 0.85, 0.9, 0.95, 1);

sub exists {
    my $skill = shift;
    return commands::exists("bin/skills/$skill.pl");
}

sub execute {
    my $skill = shift;
    return commands::execute("bin/skills/$skill.pl", $skill, @_);
}

sub require {
    my $skill = shift;
    my $level = shift;
    my $name = shift // $ENV{'USERNAME'};

    return 1 if (db::selectrow_array("select 1 from skills where user_name = ? and skill_name = ? and level >= ?", undef, $name, $skill, $level));

    die "Level $level $skill required\n";
}

sub getAll {
    return @{db::selectall_arrayref("select skill_name, level, experience from skills where user_name = ?", undef, $ENV{'USERNAME'})};
}

sub get {
    my $username = shift;
    my $skill = shift;
    my ($level, $experience) = db::selectrow_array("select level, experience from skills where user_name = ? and skill_name = ?", undef, $username, $skill);
    $level = 0 unless defined $level;
    $experience = 0 unless defined $experience;
    return ($level, $experience);
}

sub getLevel {
    my $skill = shift;
    my $name = shift;
    $name = $ENV{'USERNAME'} unless defined $name;

    my $level = db::selectrow_array("select level from skills where user_name = ? and skill_name = ?", undef, $name, $skill);

    $level = 0 unless defined $level;

    return $level;
}

sub addExp {
    my $name = shift;
    my $skill = shift;
    my $exp = shift;
    return 0 != db::do('update skills set experience = experience + ? where user_name = ? and skill_name = ?', undef, $exp, $name, $skill);
}

sub requireLevel {
    my $skill = shift;
    my $requiredLevel = shift;
    my $name = shift;
    $name = $ENV{'USERNAME'} unless defined $name;

    my $count = db::selectrow_array('select count(1) from skills where user_name=? and skill_name=? and level >= ?', undef, $name, $skill, $requiredLevel);

    die "Requires $skill level $requiredLevel\n" unless $count >= 1;
}

sub requiredExp {
    my $level = shift;

    return 0 if $level == 0;
    return undef if $level >= $max_level;
    return 10 ** $level;
}

sub randomFailure($$) {
    my ($skill, $name) = @_;
    my $level = getLevel $skill, $name;
    
    if ($level < 0) {
        $level = 0
    } elsif ($level > $max_level) {
        $level = $max_level;
    }

    return rand() > $failure_table[$level];
}

sub train {
    my $username = shift;
    my $skill = shift;

    die "skill $skill does not exist\n" unless skills::exists $skill;

    my ($level, $experience) = skills::get $username, $skill;
    my $requiredExp = requiredExp $level;

    die "max level already reached\n" unless defined $requiredExp;
    die "total level cap already reached\n" unless totalLevel($username) < 100;
    die "${\(format::number $requiredExp)} experience required to train $skill\n" if $requiredExp > $experience;
    
    $level = $level + 1;
    db::do('replace into skills (user_name, skill_name, level, experience) values (?, ?, ?, ?)', undef, $username, $skill, $level, $experience - $requiredExp) or die;
    return $level;
}

sub totalLevel {
    my $username = shift // $ENV{'USERNAME'};
    return db::selectrow_array('select IFNULL(sum(level), 0) from skills where user_name = ?', undef, $username);
}

1;