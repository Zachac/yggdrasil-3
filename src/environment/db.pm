#!/usr/bin/perl
package db;

use strict;
use warnings;
use DBI;

use environment::env;

my $driver   = "SQLite"; 
my $database = "$ENV{'DIR'}/yggdrasil.db";
my $options = "foreign keys=True";
my $dsn = "DBI:$driver:dbname=$database;$options";
my $userid = "";
my $password = "";

our $conn = DBI->connect($dsn, $userid, $password, { RaiseError => 1 }) or die $DBI::errstr;

$conn->do("CREATE TABLE IF NOT EXISTS user (
	user_name VARCHAR(20) NOT NULL PRIMARY KEY,
	password CHAR(43) NOT NULL,
	room_id INTEGER NOT NULL DEFAULT 1
);");

$conn->do("CREATE TABLE IF NOT EXISTS room (
	room_id INTEGER NOT NULL PRIMARY KEY,
	room_name VARCHAR(20) NOT NULL UNIQUE,
	description_id INTEGER NOT NULL DEFAULT 1
);");

$conn->do("CREATE TABLE IF NOT EXISTS description (
	description_id INTEGER NOT NULL PRIMARY KEY,
	description VARCHAR(500) NOT NULL UNIQUE
);");

$conn->do("insert or ignore into description(description) values ('It looks like a normal room.');");
$conn->do("insert or ignore into room(room_name) values ('root/spawn');");

warn "Database connected!\n";


1;
