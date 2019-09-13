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
	location INTEGER NOT NULL
);");

$conn->do("CREATE TABLE IF NOT EXISTS room (
	location INTEGER NOT NULL PRIMARY KEY,
	room_name VARCHAR(20) NOT NULL UNIQUE
);");

$conn->do("insert or ignore into room(location,room_name) values (0, 'root/spawn');");

warn "Database connected!\n";


1;
