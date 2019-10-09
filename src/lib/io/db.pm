#!/usr/bin/perl
package db;

use strict;
use warnings;

use environment::db;
use YAML qw(Dump) ;

sub dump() {
    my %db = ();
    my @tables = @{$db::conn->selectcol_arrayref('select name from sqlite_master where type="table"')};

    for my $t (@tables) {
        my @headers = @{$db::conn->selectcol_arrayref('select name from pragma_table_info(?)', undef, $t)};
        my @headers_comma = map {"$_,"} @headers;
        my $cols = "@headers_comma";
        chop($cols);

        my @rows = @{$db::conn->selectall_arrayref("select $cols from $t", undef)};
        my @mapped_rows = ();
        for (@rows) {
            my %row = ();
            my $i = 0;
            for my $val (@$_) {
                $row{$headers[$i]} = $val;
                $i++;
            }

            push @mapped_rows, \%row;
        }
        
        $db{$t} = \@mapped_rows;
    }

    local $YAML::UseHeader = 0;
    print Dump(\%db);
}

1;
