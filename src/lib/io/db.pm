#!/usr/bin/perl
package db;

use strict;
use warnings;

use YAML qw(Dump Load);
use File::Find;

use environment::env;
use environment::db;
use lib::io::file;
use lib::io::format;

sub dump();
sub load();
sub loadFile($);
sub loadData($$);
sub loadTable($$$);
sub loadRow($$$$);

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
            file::print "$ENV{'DIR'}/data/tables/$t.yml", Dump {$t => \@mapped_rows};
            print "dumped $t: ${\($#mapped_rows + 1)} rows\n";
        }
    }
}

sub load() {
    # for each yaml file in the data folder...
    find(sub {
        return unless $_ =~ /.*\.yml/;
        loadFile("$File::Find::dir/$_");
    }, "$ENV{'DIR'}/data/");
}

sub loadFile($) {
    my $file = shift;
    my $relPath = File::Spec->abs2rel($file, $ENV{'DIR'});
    my $data = Load(file::slurp($file));
    
    eval {
        my ($table_count, $row_count) = loadData($file, $data);
        print "processed $table_count tables with $row_count total rows from $relPath\n";
    };

    warn $@ if $@;
}

sub loadData($$) {
    my ($identifier, $data) = @_;

    die "Expected hash reference for $identifier\n" unless (defined $data && ref $data eq 'HASH');

    my $row_count = 0;
    my $table_count = 0;
    for my $k (keys %$data) {
        $table_count++;
        $row_count += loadTable($identifier, $k, %$data{$k});
    }

    return ($table_count, $row_count);
}

sub loadTable($$$) {
    my ($identifier, $table_name, $rows) = @_;

    die "Expected arrayref of rows for table $identifier:$table_name\n" unless (defined $rows && ref $rows eq 'ARRAY');
    
    my $row_count = 0;
    for my $row (@$rows) {
        loadRow($identifier, $table_name, $row_count++, $row);
    }

    return $row_count;
}

sub loadRow($$$$) {
    my ($identifier, $table_name, $row_count, $row) = @_;

    die "Expected table of values for row $identifier:$table_name:$row_count\n" unless (defined $row && ref $row eq 'HASH');

    my @collumns = keys %$row;
    my @values = @$row{@collumns};
    my @place_holders = format::withCommas(map {"?"} @collumns);
    return 0 == $db::conn->do("insert or replace into $table_name(${\(format::withCommas(@collumns))}) values (@place_holders)\n", undef, @values);
}

1;