#!/usr/bin/perl
package db;

use strict;
use warnings;
use DBI;

use environment::env;

my $driver   = "SQLite"; 
my $database = "$ENV{'DIR'}/yggdrasil.db";
my $dsn = "DBI:$driver:dbname=$database";
my $userid = "";
my $password = "";

our $conn = DBI->connect($dsn, $userid, $password, { RaiseError => 1 }) or die $DBI::errstr;

$conn->do("CREATE TABLE IF NOT EXISTS USER (
	USER_NAME VARCHAR(20) NOT NULL UNIQUE,
	PASSWORD CHAR(43) NOT NULL,
	LOCATION LONG NOT NULL
);");

warn "Database connected!\n";


1;
