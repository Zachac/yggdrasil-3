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
	user_name NOT NULL PRIMARY KEY,
	password NOT NULL,
	location NOT NULL DEFAULT 'NULL'
);");

$conn->do("CREATE TABLE IF NOT EXISTS room (
	location UNIQUE PRIMARY KEY,
	room_name,
	description
);");

$conn->do("CREATE TABLE IF NOT EXISTS links (
	link_name,
	src_location,
	dest_location
);");

$conn->do("insert or ignore into room(location, room_name, description) values ('NULL', 'root/spawn', 'It looks like a very normal room.');");

warn "Database connected!\n";


1;
