node default {
    # include perlbrew here to make sheep::perl work
    include perlbrew
    $perlbin = "/usr/local/perlbrew/perls/perl-5.16.2/bin"
    $perl = "perl-5.16.2"
        
    include sheep
    include sheep::ssh

    sheep::perl {  $perl: }
    
    # include sheep::exim
    include sheep::configs
    include sheep::packages    
    include sheep::user::admins
    
    include sheep::web::laurielapworth
    include sheep::web::imageeasel
}
