use strict;
use warnings;

use Path::Class;
use Plack::Middleware::TemplateToolkit;
use Plack::Builder;
use Plack::Util;
use Plack::Middleware::Static;
use Plack::App::URLMap;

my $urlmap = Plack::App::URLMap->new;

my $vhosts = dir('/vhosts');

foreach my $dir ( $vhosts->children() ) {
    next unless $dir->is_dir();

    my $domain = $dir->dir_list(-1);
    next if $domain =~ /sheep_lib/;

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
        my $local_app = Plack::Util::load_psgi( $app_file->stringify() );
        my $url       = "http://$domain/";

        warn "M: $url -> $app_file";
        $urlmap->map( $url => $local_app );

    }
}

my $app = $urlmap->to_app;

return builder {
    $app;
}
