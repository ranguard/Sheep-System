package Sheep::Plack;

use Moose;

use Path::Class;
use Plack::App::File;
use Plack::Builder;
use Plack::Middleware::AccessLog;
use Plack::Middleware::Static;
use Plack::Middleware::TemplateToolkit;
use Plack::Middleware::ReverseProxy;
use Sheep;

has 'psgi_name' => ( is => 'ro', isa => 'Str', required => 1 );
has 'folder'    => ( is => 'rw', isa => 'Str' );
has 'log_dir'   => ( is => 'rw', isa => 'Path::Class::Dir' );
has 'access_log' => ( is => 'rw', isa => 'Path::Class::File' );
has 'error_log'  => ( is => 'rw', isa => 'Path::Class::File' );

around BUILDARGS => sub {
    my ( $orig, $class, %args ) = @_;

    $args{log_dir} = Sheep->is_dev
        ? dir( '/tmp/psgi_logs', $args{psgi_name} )

        : dir( "/vhosts/logs/", $args{psgi_name} );

    $args{log_dir}->mkpath();

    $args{access_log} ||= $args{log_dir}->file('access.log');
    $args{error_log}  ||= $args{log_dir}->file('error.log');

    return $class->$orig(%args);
};

sub outer_wrapper {
    my ( $self, $app ) = @_;

    # write Access logs to files
    open my $logfh, ">>", $self->access_log->stringify or die $!;
    $logfh->autoflush(1);

    my $vhost = $self->psgi_name;

    $app = Plack::Middleware::AccessLog->wrap(
        $app,
        format =>
            "%h %l %u %t \"%r\" %>s %b \"%{Referer}i\" \"%{User-Agent}i\" \"-\"$vhost",
        logger => sub { print $logfh @_ }
    );

    $app = Plack::Middleware::ReverseProxy->wrap($app);

    return $app;
}

sub root_path {
    my $self = shift;

    my $d
        = Sheep->is_dev
        ? dir("root")
        : dir( '/vhosts/' . $self->folder . '/root' );

    unless ( -d $d ) {

        # Try htdocs
        $d
            = Sheep->is_dev
            ? dir("htdocs")
            : dir( '/vhosts/' . $self->folder . '/htdocs' );
    }

    return $d;
}

sub standard_tt {
    my ( $self, $conf ) = @_;

    my $app = Plack::Middleware::TemplateToolkit->new(
        root => $conf->{roots},

        #    404  => "page_not_found.html",
        #   500  => "internal_server_error.html",
    )->to_app;

    foreach my $root ( @{ $conf->{roots} } ) {

        # Static path
        $app = Plack::Middleware::Static->wrap(
            $app,
            path => qr{^/static/},
            root => "$root",
        );

        # Files
        $app = Plack::Middleware::Static->wrap(
            $app,
            path => qr{[gif|png|jpg|swf|ico|mov|mp3|pdf|js|css]$},
            root => "$root",
        );

        # Specific
        $app = Plack::Middleware::Static->wrap(
            $app,
            path => qr{^/[robots\.txt|sitemap\.xml]$},
            root => "$root",
        );

    }

    $app = $self->outer_wrapper($app);

    return builder {
        $app;
    }

}

1;
