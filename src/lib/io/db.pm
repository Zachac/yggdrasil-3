#!/usr/bin/perl
package db;

use strict;
use warnings;

use YAML qw(Dump);

use environment::env;
use environment::db;
use lib::io::file;
use lib::io::format;

sub dump() {
    my @tables = @{$db::conn->selectcol_arrayref('select name from sqlite_master where type="table"')};

    local $YAML::UseHeader = 0;
    for my $t (@tables) {
        my @headers = @{$db::conn->selectcol_arrayref('select name from pragma_table_info(?)', undef, $t)};
        my @rows = @{$db::conn->selectall_arrayref("select ${\(format::withCommas(@headers))} from $t", undef)};

        my @mapped_rows = ();
        for my $r (@rows) {
            my %row = ();
            @row{@headers} = @$r;
            push @mapped_rows, \%row;
        }
        
        if (@mapped_rows) {
            file::print "$ENV{'DIR'}/data/$t.yml", Dump {$t => \@mapped_rows};
            print "dumped $t: ${\($#mapped_rows + 1)} rows\n";
        }
    }
}

1;
