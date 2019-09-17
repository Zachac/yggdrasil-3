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

sub level {
    my $skill = shift;
    return $db::conn->selectrow_array("select level from skills where user_name = ? and skill_name = ?", undef, $ENV{'USERNAME'}, $skill);
}

sub experience {
    my $skill = shift;
    return $db::conn->selectrow_array("select experience from skills where user_name = ? and skill_name = ?", undef, $ENV{'USERNAME'}, $skill);
}

sub all {
    return @{$db::conn->selectall_arrayref("select skill_name, level, experience from skills where user_name = ?", undef, $ENV{'USERNAME'})};
}

1;