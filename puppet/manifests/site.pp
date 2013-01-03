node default {
    include sheep
    
    include sheep::ssh
    include sheep::configs
    include sheep::packages    
    include sheep::user::admins
}