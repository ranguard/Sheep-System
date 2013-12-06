# DEPRECIATED

Some things for setting up a basic perl Starman/Varnish server

You probably won't find this useful as it's very specific to
my setup - but feel free to have a look around and use code that
you find useful.

Dir structure:

/vhosts/sheep_lib/ - where this should be checked out

/vhosts/www.domainA.com/A_app.psgi
/vhosts/www.domainB.com/B_app.psgi

# /vhosts/www.domainA.com/A_app.psgi
-----
use strict;
use warnings;

use lib ( 'sheep_lib', '../sheep_lib' );
use Sheep;
use Sheep::Plack;

my $slack = Sheep::Plack->new(
    psgi_name => 'domainA',
    folder    => 'www.domainA.com',
);

$slack->standard_tt(
    {    #
        roots => [ ( $slack->root_path->stringify() ) ],    #
    }
);
-----

