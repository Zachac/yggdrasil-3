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

our $conn = DBI->connect($dsn, $userid, $password, { 
    PrintError => 0,
    RaiseError => 1,
    AutoCommit => 1,
}) or die $DBI::errstr;
$conn->do('PRAGMA case_sensitive_like = ON');

warn "Database connected!\n";

1;
