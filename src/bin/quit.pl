#!/usr/bin/perl

use strict;
use warnings;

use lib::model::user;


user::clean($ENV{'USERNAME'});

kill -9, getpgrp($$) or die "Could not terminate successfully!";
