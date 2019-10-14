#!/usr/bin/perl
package format;

use strict;
use warnings;

use Lingua::EN::Inflexion qw( noun );

sub withArticle($);

sub withCount($$) {
    my $item = withArticle shift;
    my $count = shift;

    if ($count <= 1) {
        return $item;
    } else {
        return "$item x$count";
    }
}

sub isPlural($) {
    return noun(shift)->is_plural();
}

sub withArticle($) {
    my $value = shift;
    my $noun = noun($value);

    unless ($noun->is_plural) {
        return $noun->indef_article() . " $value"
    } else {
        return "some $value";
    }
}

sub withCommas(@) {
    return join(', ', @_);
}

sub getCounts {
    return () if @_ <= 0;

    @_ = sort @_;
    
    my @result = ();
    my $count = 0;
    my $lastValue = $_[0];

    for (@_) {
        if ($lastValue eq $_) {
            $count++;
        } else {
            push @result, withCount($lastValue, $count);
            $lastValue = $_;
            $count = 1;
        }
    }

    push @result, withCount($lastValue, $count);

    return @result;
}

1;