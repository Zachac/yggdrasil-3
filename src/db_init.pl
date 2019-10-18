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


$dbh->do('CREATE OR REPLACE DATABASE yggdrasil');
$dbh->do('CREATE OR REPLACE USER abc IDENTIFIED BY "def"');
$dbh->do('GRANT SELECT, INSERT, UPDATE ON yggdrasil.* TO abc');

$dbh->do('use yggdrasil');

find (sub {
    return unless $_ =~ /.*\.sql/;
    
    my $file = file::slurp("$File::Find::dir/$_");
    for (split(';', $file)) {
        next if /^\s$/;
        say $_;
        $dbh->do($_) or die $DBI::errstr;
    }

}, "${\(env::dir())}/data/ddl");

$dbh->disconnect() or die $dbh->errstr;
say "Created database";


# finally, load the data/ folder into db
# require lib::io::db;
# db::load();

1;