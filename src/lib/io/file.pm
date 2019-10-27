#!/usr/bin/perl
package file;

use strict;
use warnings;

use Fcntl qw(O_NONBLOCK O_WRONLY :flock);
use File::Path qw(make_path);
use File::Basename;
use File::Spec;

sub print($$) {
    my $filename = shift;
    my $value = shift;
	my $directory = dirname($filename);

    unless ( -d $directory ) {
        make_path($directory) or die "Could not create $directory: $!";
    }

    open(my $handle, '>', $filename) or die "Could not open $filename: $!";
    print $handle $value;
    close $handle;
}

sub printnb {
    die "Not enough arguments!" unless @_ >= 1;
    my $filename = shift;
	my $directory = dirname($filename);

    sysopen(my $fh, $filename, O_NONBLOCK|O_WRONLY) or return 0;
    print $fh @_;
    close $fh;
    return 1;
}

sub slurp {
    my $filename = "@_";
    local $/;
    open(my $fh, "<", $filename) or die "Could not open $filename: $!";
    return <$fh>;
}

sub touch {
    my $filename = shift;
	my $directory = dirname($filename);

    unless ( -d $directory ) {
        make_path($directory) or die "Could not create $directory: $!";
    }

    open(my $fh, ">>", $filename) or die "Can't touch '$filename'\n";
    print $fh "";
    close $fh;
}

sub initPathTo {
	my $directory = dirname(shift);

    unless ( -d $directory ) {
        make_path($directory) or die "Could not create $directory: $!";
    }
}

sub symlink {
    my $old_file = shift;
    my $new_file = shift;
	my $directory = dirname($new_file);
    
    unless ( -d $directory ) {
        make_path($directory) or die "Could not create $directory: $!";
    }

    my $relative_path = File::Spec->abs2rel($old_file, $directory);

    symlink($relative_path, $new_file);
}

sub mkfifo {
    my $fifo = shift;
    
    unless ( -e $fifo) {
        initPathTo($fifo);
        system("mkfifo", "$fifo");
    }

}

sub remove {
    die "Not enough arguments!" unless @_ >= 1;
    my $filename = "@_";
    unlink $filename if ( -e $filename );
}

sub lock($) {
    my $file_name = shift;
    open my $fh, ">>", $file_name or return undef;
    flock $fh, LOCK_EX|LOCK_NB or return undef;
    return $fh;
}

1;