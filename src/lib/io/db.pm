#!/usr/bin/perl
package db;

use strict;
use warnings;

use YAML qw(Dump Load);
use File::Find;
use Tie::IxHash;
use File::Basename;

use lib::env::env;
use lib::env::db;
use lib::io::file;
use lib::io::format;
use lib::io::stdio;

sub dump();
sub load();
sub loadFile($);
sub loadData($;$);
sub loadTable($$;$);
sub loadRow($$;$$);

# dump all tables and rows into the data/tables folder in YAML format, 
# deletes existing files as neccessary 
sub dump() {
    my @tables = @{db::selectcol_arrayref('SELECT table_name FROM information_schema.tables where table_type = "BASE TABLE"')};

    local $YAML::UseHeader = 0;
    local $YAML::SortKeys = 0;
    for my $t (@tables) {
        my @headers = @{db::selectcol_arrayref('select column_name from information_schema.columns where table_name = ?', undef, $t)};
        my @rows = @{db::selectall_arrayref("select ${\(format::withCommas(@headers))} from $t", undef)};

        my @mapped_rows = ();
        for my $r (@rows) {
            my %row = ();
            tie(%row, 'Tie::IxHash');
            @row{@headers} = @$r;
            push @mapped_rows, \%row;
        }
        
        if (@mapped_rows) {
            file::print "${\(env::dir())}/data/tables/$t.yml", Dump {$t => \@mapped_rows};
            stdio::log "dumped $t: ${\($#mapped_rows + 1)} rows\n";
        }
    }
}

# loads all files from the data/ folder recursively
# for each file, use the loadFile function to consume it into the db
sub load() {
    db::do('SET FOREIGN_KEY_CHECKS=0');

    local $YAML::Preserve = 1;
    return find(sub {
        return unless $_ =~ /.*\.yml/;
        loadFile("$File::Find::dir/$_");
    }, "${\(env::dir())}/data/");
}

sub loadFile($) {
    my $file = shift; # abs path to yaml file to load
    my $relPath = File::Spec->abs2rel($file, env::dir());
    my $data = Load(file::slurp($file));
    
    eval {
        my ($table_count, $row_count) = loadData($data, $file);
        stdio::log "processed $table_count tables with $row_count total rows from $relPath\n";
    };

    warn $@ if $@;
}

sub loadData($;$) {
    my $data = shift; # hashref of tables to insert
    my $identifier = shift // 'default'; # identifier for debuging

    die "Expected hash reference for $identifier\n" unless (defined $data && ref $data eq 'HASH');

    my $row_count = 0;
    my $table_count = 0;
    for my $table_name (keys %$data) {
        $table_count++;
        $row_count += loadTable($table_name, %$data{$table_name}, $identifier);
    }

    return ($table_count, $row_count);
}

sub loadTable($$;$) {
    my $table_name = shift; # table name to insert the rows into
    my $rows = shift; # arrayref of rows as hashrefs
    my $identifier = shift // 'default'; # identifier for debuging

    die "Expected arrayref of rows for table $identifier:$table_name\n" unless (defined $rows && ref $rows eq 'ARRAY');
    
    my $row_count = 0;
    for my $row (@$rows) {
        loadRow($table_name, $row, $row_count++, $identifier);
    }

    return $row_count;
}

sub loadRow($$;$$) {
    my $table_name = shift; # table name to insert the row into
    my $row = shift; # hashref of collumns mapped to values
    my $row_count = shift // 0; # row count for debugging
    my $identifier = shift // 'default'; # identifier for debuging

    die "Expected table of values for row $identifier:$table_name:$row_count\n" unless (defined $row && ref $row eq 'HASH');

    my @collumns = keys %$row;
    my @values = @$row{@collumns};
    my @place_holders = format::withCommas(map {"?"} @collumns);
    my $affected_rows = eval { db::do("insert into $table_name(${\(format::withCommas(@collumns))}) values (@place_holders)\n", undef, @values) };

    return 0 == $affected_rows if defined $affected_rows;

    warn $db::conn->errstr, " at $identifier:$table_name:$row_count\n";
    return 0;
}

sub require($) {
    my $script = shift;
    my $basename = basename $script;
    my $lock = 0 != db::do('insert ignore into init_scripts(script) values(?)', undef, $script);
    
    return undef unless $lock;

    local $0 = $basename;
    my $result = do $script;

    unless (defined($result)) {
        warn "ERROR in $basename\n\t$@";
    }

    db::do('update init_scripts set result = ?', undef, $result);
    return $result;
}

1;