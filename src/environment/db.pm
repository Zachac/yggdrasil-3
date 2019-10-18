#!/usr/bin/perl
package db;

use strict;
use warnings;
use DBI;

my $driver   = "MariaDB"; 
my $database = "yggdrasil";
my $dsn = "DBI:$driver:dbname=$database;host=localhost";
my $username = "abc";
my $password = "def";

# use sudo to connect
our $conn = DBI->connect($dsn, $username, $password, { 
    PrintError => 0,
    RaiseError => 1,
    AutoCommit => 1,
}) or die $DBI::errstr;

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

warn "Database connected!\n";

1;
