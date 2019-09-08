#! /usr/bin/perl

# source https://unix.stackexchange.com/a/513691
# Uncle Billy https://unix.stackexchange.com/users/325065/uncle-billy
package tcpsrv;

use strict;
use IO::Socket;

sub tcpsrv {

        die "usage: $0 host:port { shell_cmd | cmd args ... }\n" unless @_ >= 2;

        my $h = shift;
        my $s=new IO::Socket::INET(ReusePort=>1, Listen=>6, LocalAddr=>$h)
                or die "IO::Socket::INET($h): $!";

        warn "listening on ", $s->sockhost, "/", $s->sockport, "\n";
        $SIG{CHLD} = sub { use POSIX qw(WNOHANG); 1 while waitpid(-1, WNOHANG) > 0 };

        while(1){
                my $a = $s->accept or do { die "accept: $!" unless $!{EINTR}; next };
                
                warn "connection from ", $a->peerhost, "/", $a->peerport, "\n";
                die unless defined(my $p = fork);
                close($a), next if $p;
                
                open STDIN, "<&", $a and open STDOUT, ">&", $a or die "dup: $!";
                
                close $s and close $a or die "close: $!";
                
                exec(@_); die "exec @_: $!";
        }
}

1;
