package Sheep;

use strict;
use warnings;

use Sys::Hostname;

my $host = hostname;

sub is_dev {
    return $host eq 'sheep' ? 0 : 1;
}

1;
