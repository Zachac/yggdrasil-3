#!/usr/bin/perl
use strict;
use warnings;

use Cwd;
use File::Basename;

use lib dirname(Cwd::realpath($0));

use lib::io::stdio;
use lib::model::user;
use lib::model::commands;
use lib::crypto::hash;
use constants::env;



sub login;
sub getUsername;
sub createUser;

STDOUT->autoflush;
open(STDERR, ">&STDOUT");


sub login {
    
    my $username = getUsername();
    my $password = hash::password($username, stdio::prompt("Please enter the password:"));
    my $lock;
    my $stdout;

    until ($lock = eval {user::login($username, $password)}) {
        print "$@";
        $username = getUsername();
        $password = hash::password($username, stdio::prompt("Please enter the password:"));
    }

    print "Logged in!\n";

    return ($username, $lock, $stdout);
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
    
    user::create(@_, $password1);
}

sub commandPrompt {
    commands::run("jump", "-f");

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
    my $stdout = user::stdout($username, "<");

    while (1) {
        print($_, "\n") while (<$stdout>);
    }

    exit 0;
}

my ($username, $lock) = login();
readStdout($username);
commandPrompt();

print "Goodbye!\n"
