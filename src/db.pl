#!/usr/bin/perl
use strict;
use warnings;

use feature qw(say);

use Cwd;
use File::Basename;
use File::Find;
use English qw(-no_match_vars);
use DBI;

use lib dirname(Cwd::realpath($PROGRAM_NAME));
use lib::env::env;
use lib::io::file;
use lib::io::stdio;

sub resetDatabase();
sub runInitializingScripts();
sub execSqlFile($$);
sub getOffset($);

my $dsn = "DBI:MariaDB:host=localhost";
my $dbh = DBI->connect($dsn, undef, undef, { 
    PrintError => 0,
    RaiseError => 1,
    AutoCommit => 1,
}) or die $DBI::errstr;


die "usage $PROGRAM_NAME [init|dump|restore]" unless @ARGV;

my $mode = "@ARGV";

if ($mode eq "restore") {
    resetDatabase();
    require lib::io::db;
    db::load();
} elsif ($mode eq "dump") {
    require lib::io::db;
    db::dump();
} elsif ($mode eq "init") {
    resetDatabase();
    runInitializingScripts();
}

sub resetDatabase() {
    stdio::log "dropping database\n";
    $dbh->do('DROP DATABASE IF EXISTS yggdrasil');
    $dbh->do('CREATE DATABASE yggdrasil');
    $dbh->do('CREATE USER IF NOT EXISTS abc IDENTIFIED BY "def"');
    $dbh->do('GRANT SELECT, INSERT, UPDATE, DELETE ON yggdrasil.* TO abc');
    $dbh->do('use yggdrasil');

    # execute each .sql file in data folder
    find (sub {
        if ($_ =~ /.*\.sql/) {
            stdio::log "executing $_\n";
            execSqlFile $File::Find::dir, $_;
        }
    }, "${\(env::dir())}/data");
}

sub runInitializingScripts() {
    require lib::io::db;
    
    # execute each .pl file in data folder
    find (sub {
        if ($_ =~ /.*\.pl/) {
            db::require("$File::Find::dir/$_");
        }
    }, "${\(env::dir())}/data");
}

sub execSqlFile($$) {
    my $dir = shift;
    my $fileName = shift;
    my $file = file::slurp("$dir/$fileName");

    my $line = 1;
    for my $sql (split /;/, $file) {
        my $line_offset = $line + getOffset($sql);

        if ($sql =~ /\S/) {
            unless (defined eval {$dbh->do($sql)}) {
                die "$DBI::errstr from offset $line_offset in $_\n"
            }
        }
        
        $line += ($sql =~ tr/\n//);
    }
}

sub getOffset($) {
    my $line = shift;
    my $start = $-[0] if $line =~ /\S/;
    return substr($line, 0, $start // 0) =~ tr/\n//;
}

$dbh->disconnect() or die $dbh->errstr;

stdio::log "Finished initializing database";

1;