node default {
    include sheep
    
    include sheep::configs
    include sheep::packages    
    include sheep::user::admins
}