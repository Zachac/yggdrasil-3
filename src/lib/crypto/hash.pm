#!/usr/bin/perl
package hash;

use strict;
use warnings;

use Digest::SHA qw(sha256_base64);

sub password {
    return sha256_base64(@_);
}

1;