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

unlink "$ENV{'DIR'}/yggdrasil.db";
find (\&init, "$ENV{'DIR'}/src");

require lib::io::db; # redundant
db::load();


sub init {
    return unless ($_ =~ /.*\.pm/);

    my $file = "$File::Find::dir/$_";
    my $relPath = File::Spec->abs2rel($file, "$ENV{'DIR'}/src");
    
    require $relPath;
}