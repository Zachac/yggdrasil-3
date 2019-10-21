#!/usr/bin/perl
use strict;
use warnings;

use Cwd;
use File::Basename;

use lib dirname(Cwd::realpath($0));

use lib::io::stdio;
use lib::model::user::user;
use lib::model::commands::commands;
use lib::crypto::hash;
use lib::env::env;

# set the process group to be different from the server.
# that way, we don't kill the entire server when we shutdown
# the client.
setpgrp();

# if we are running locally, die softly and trigger any END blocks
# when the user interrupts
$SIG{'INT'} = sub {delete $SIG{'INT'}; die "Interrupted\n"};
my $parent_pid = $$;

sub login;
sub getUsername;
sub createUser;

STDOUT->autoflush;
open(STDERR, ">&STDOUT");


sub login {
    
    my $username = getUsername();
    my $password = hash::password($username, stdio::prompt("Please enter the password:"));

    until (defined eval {user::login($username, $password)}) {
        print "$@";
        $username = getUsername();
        $password = hash::password($username, stdio::prompt("Please enter the password:"));
    }

    print "Logged in!\n";

    return $username;
}

sub getUsername {
    my $username;

    do {
        $username = stdio::prompt("Please enter a username:");

        until (user::isValidUsername $username) {
            print "Invalid username,\n";
            $username = stdio::prompt("Please enter a username: ");
        }

        if (! user::exists $username) {
            print "User not found!\n";
            my $response = stdio::prompt("Would you like to create a new user (Y/N)?");

            if ($response =~ /^(y|yes)$/i) {
                createUser $username
            }
        }
    } until (user::exists $username);

    return $username;
}

sub createUser {
    my $password1 = hash::password(@_, stdio::prompt("Please enter a new password:"));
    my $password2 = hash::password(@_, stdio::prompt("Please re-enter the password:"));

    until ($password1 eq $password2) {
        print "The passwords do not match!\n";

        $password1 = hash::password(@_, stdio::prompt("Please enter a new password:"));
        $password2 = hash::password(@_, stdio::prompt("Please re-enter the password:"));
    }
    
    unless (user::create(@_, $password1)) {
        print "Failed to create user, does this user already exist?\n";
    }
}

sub commandPrompt {
    commands::run("look");

    while (1) {
        my @prog = stdio::readArgs();

        if ("@prog" =~ /^\s*$/) {
        } elsif (commands::isValid(@prog)) {
            commands::run(@prog);
        }  else {
            print("Invalid command!");
        }
    }

}

sub readStdout {
    die unless defined(my $child_pid = fork);
    return if ($child_pid);

    my $username = shift;
    my $stdout = client::getStdout($username);

    while (1) {
        print($_, "\n") while (<$stdout>);
    }

    exit 0;
}

my $username = login();

eval {
    readStdout($username);
    system env::dir() . '/src/tick_daemon.pl';
    commandPrompt();
};

END {
    if ($ENV{'USERNAME'} && $parent_pid == $$) {
        commands::runCommand("quit");
    }
}
