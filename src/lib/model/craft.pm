#!/usr/bin/perl
package craft;

use strict;
use warnings;

use environment::db qw(conn);

$db::conn->do("CREATE TABLE IF NOT EXISTS recipe_requirements (
    recipe_name NOT NULL,
    required_name NOT NULL,
    UNIQUE(recipe_name, required_name)
);");

$db::conn->do("CREATE TABLE IF NOT EXISTS recipe (
    recipe_name NOT NULL PRIMARY KEY,
    skill_name,
    required_level NOT NULL DEFAULT 0,
    experience NOT NULL DEFAULT 0
);");

1;