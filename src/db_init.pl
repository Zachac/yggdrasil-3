#!/usr/bin/perl
use strict;
use warnings;

use Cwd;
use File::Basename;
use File::Find;
use File::Spec;

use lib dirname(Cwd::realpath($0));
use environment::env;

sub init;


# delete the original database,
unlink "${\(env::dir())}/yggdrasil.db";


# for each perl module, in src/
#   use require to load it,
#   if it has db table initialze code,
#   then the code will get run with the require
find (\&init, "${\(env::dir())}/src");


# finally, load the data/ folder into db
require lib::io::db;
db::load();


# initialize the given file found from the find callback
sub init {
    return unless ($_ =~ /.*\.pm/);

    my $file = "$File::Find::dir/$_";
    my $relPath = File::Spec->abs2rel($file, "${\(env::dir())}/src");
    
    require $relPath;
}
