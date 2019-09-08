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
use constants::perl::env;



sub login;
sub getUsername;
sub createUser;

STDOUT->autoflush;



sub login {
    
    my $username = getUsername();
    my $password = hash::password($username, stdio::prompt("Please enter the password:"));
    my $lock;

    until ($lock = eval {user::login($username, $password)}) {
        print "$@";
        $username = getUsername();
        $password = hash::password($username, stdio::prompt("Please enter the password:"));
    }

    print "Logged in!\n";

    return ($username, $lock);
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

my ($username, $lock) = login();

while (1) {
    my @prog = stdio::readArgs();

    if (! length scalar(@prog)) {
    } elsif (commands::isValid(@prog)) {
        commands::run(@prog);
    }  else {
        print("Invalid command!");
    }
}


print "Goodbye!\n"
