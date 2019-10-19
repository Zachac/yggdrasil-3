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
use environment::env;
use lib::io::file;


my $dsn = "DBI:MariaDB:host=localhost";
my $dbh = DBI->connect($dsn, undef, undef, { 
    PrintError => 0,
    RaiseError => 1,
    AutoCommit => 1,
}) or die $DBI::errstr;


$dbh->do('DROP DATABASE yggdrasil');
$dbh->do('CREATE DATABASE yggdrasil');
$dbh->do('CREATE USER IF NOT EXISTS abc IDENTIFIED BY "def"');
$dbh->do('GRANT SELECT, INSERT, UPDATE, DELETE ON yggdrasil.* TO abc');

$dbh->do('use yggdrasil');

sub getOffset($) {
    my $line = shift;
    my $start = $-[0] if $line =~ /\S/;
    return substr($line, 0, $start // 0) =~ tr/\n//;
}

find (sub {
    return unless $_ =~ /.*\.sql/;
    
    my $file = file::slurp("$File::Find::dir/$_");
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

}, "${\(env::dir())}/data/ddl");

$dbh->disconnect() or die $dbh->errstr;
say "Created database";


# finally, load the data/ folder into db
require lib::io::db;
db::load();

1;