#! /usr/bin/perl

# source https://unix.stackexchange.com/a/513691
# Uncle Billy https://unix.stackexchange.com/users/325065/uncle-billy
package tcpsrv;

use strict;
use IO::Socket;

sub tcpsrv {

        die "usage: $0 host:port { shell_cmd | cmd args ... }\n" unless @_ >= 2;

        my $host = shift;
        my $socket=new IO::Socket::INET(ReusePort=>1, Listen=>6, LocalAddr=>$host)
                or die "IO::Socket::INET($host): $!";

        warn "listening on ", $socket->sockhost, "/", $socket->sockport, "\n";
        $SIG{CHLD} = sub { use POSIX qw(WNOHANG); 1 while waitpid(-1, WNOHANG) > 0 };

        while(1){
                my $acepted_socket = $socket->accept or do { die "accept: $!" unless $!{EINTR}; next };
                warn "connection from ", $acepted_socket->peerhost, "/", $acepted_socket->peerport, "\n";
                
                die unless defined(my $parent = fork);
                if ($parent) {
                        close($acepted_socket);
                        next;
                }
                
                open(STDIN, "<&", $acepted_socket) or die "dup: $!";
                open(STDOUT, ">&", $acepted_socket) or die "dup: $!";
                close($socket) and close($acepted_socket) or die "close: $!";
                
                exec(@_); die "exec @_: $!";
        }
}

1;
