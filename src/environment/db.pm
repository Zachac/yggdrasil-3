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

my %prepared_statements = ();

sub getStatement($) {
    my $statement = shift;
    my $sth = $prepared_statements{$statement};

    return $sth if defined $sth;
    return $prepared_statements{$statement} = $conn->prepare($statement);
}

sub getAndExecuteStatement($;@) {
    my $statement = getStatement(shift);
    shift; # ignore attributes param
    
    return ($statement, $statement->execute(@_));
}

sub do($;@) {
    my $statement = getStatement(shift);
    shift; # ignore attributes param
    my $result = $statement->execute(@_);
    return $result;
}

sub selectall_arrayref($;@) {
    return $conn->selectall_arrayref(getStatement(shift), @_);
}

sub selectrow_array($;@) {
    return $conn->selectrow_array(getStatement(shift), @_);
}

sub selectcol_arrayref($;@) {
    return $conn->selectcol_arrayref(getStatement(shift), @_);
}

1;
