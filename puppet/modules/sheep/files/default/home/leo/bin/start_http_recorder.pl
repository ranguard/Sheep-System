#!/usr/bin/perl
#
use strict;

use HTTP::Proxy;
use HTTP::Recorder;

my $proxy = HTTP::Proxy->new;

my $agent = HTTP::Recorder->new( 
        file => "/tmp/tmpfile",
		);

$proxy->agent( $agent );

my $host = 'localhost:9090';

print "Point browser at proxy: $host \n";

$proxy->host( $host );

$proxy->start();
