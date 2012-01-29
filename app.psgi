#!/usr/bin/env perl

use strict;
use warnings;

use Path::Class;
use Plack::Middleware::TemplateToolkit;
use Plack::Builder;
use Plack::Util;
use Plack::Middleware::Static;
use Plack::App::URLMap;

use lib ('sheep_lib');

my $urlmap = Plack::App::URLMap->new;

$ENV{'VHOSTS'} = '/vhosts';

my $vhosts = dir( $ENV{'VHOSTS'} );

foreach my $dir ( $vhosts->children() ) {
    next unless $dir->is_dir();

    my $domain = $dir->dir_list(-1);

    # Find the app file
    my $app_file;
    foreach my $file ( $dir->children ) {
        next if $file->is_dir();
        if ( $file->basename =~ /psgi$/ ) {
            $app_file = $file;
            last;
        }
    }

    if ($app_file) {
        my $local_app = builder {
            Plack::Util::load_psgi "$app_file";
        };

        my $url = "http://$domain/";

        warn "Mapping $url -> $app_file";
        $urlmap->map( $url => $local_app );
    }
}

my $app = $urlmap->to_app;

return builder {
    $app;
}
