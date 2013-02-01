node default {
    include sheep
    
    include sheep::ssh
    
    $perl = "perl-5.16.2"
    sheep::perl {  $perl: }
    
    # include sheep::exim
    include sheep::configs
    include sheep::packages    
    include sheep::user::admins
}
