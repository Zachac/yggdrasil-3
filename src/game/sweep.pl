#!/usr/bin/perl
# sweep up and clean up the player files for users that
# have disconnected

use File::Basename;

sub safeUnlink;
sub getLocation;
sub processAlive;

sub sweep {
    foreach (glob("$ENV{CONNECTED_PLAYERS}/*")) {
        my $username = basename($_);
        my $proc_file = "$ENV{USERS}/$username/proc";
        my $location = getLocation $username;

        if (-e $proc_file) {
            my $proc = do{local(@ARGV, $/)=$proc_file;<>};

            unless (processAlive $proc_file) {
                safeUnlink $_, $proc_file, $location;
                print "$username has disconnected\n";
            }
        }
    }
}

sub safeUnlink {

    foreach (@_) {
        unlink $_ if ( -e $_ );
    }

}

sub getLocation {
    my $location_file = "$ENV{USERS}/@_/location";

    if (-e $location_file) {
        my $location = do{local(@ARGV, $/)=$location_file;<>};
        my $instance = "$ENV{ROOMS}/$location/$ENV{PLAYERS}/@_";
        return $instance;
    }
}

sub processAlive {
    if (-e "@_") {
        my $proc = do{local(@ARGV, $/)="@_";<>};

        kill(0, $proc);
    } else {
        0;
    }
}

1;