#!/usr/bin/perl
package foo;

use strict;
use warnings;

use lib::model::entities::resource;
use lib::model::inventory;

use Lingua::EN::Inflexion qw< noun inflect wordlist >;



# my @matches = (1, 2, 3);
# print inflect("<#i:$#matches> <N:matches> <V:were> found"), "\n";

# print resource::create('forest undergrowth', 'root/spawn'), "\n";
# print rand(), "\n";


sub create($) {
    my $item = shift;        
    my $noun = noun($item);
    my $article;
    
    if ($noun->is_singular()) {
        $article = $noun->indef_article();
    } else {$article = "the"}
    
    die "you already have a $item\n" if defined inventory::find($ENV{'USERNAME'}, $item);
    inventory::add($ENV{'USERNAME'}, $item);
}

# create('magic mirror');
# create('broken item');
create('trees');



