define sheep::user(
    $user = $name,
    $fullname = "",
    $path = "/home",
    $shell = "/bin/bash",
    $admin = false,
    $expire_password = true,
) {

    user { $user:
        home       => "$path/$user",
        managehome => true,
        ensure     => "present",
        comment    => "$fullname",
        shell      => "$shell",
        provider   => "useradd",
    }->
    # force empty password
    # setting password => "" above will result
    # in a locked user account in the first run
    # puppet bug?
    exec { "usermod --password '' $user":
        path        => "/usr/sbin",
        subscribe   => User[$user],
        refreshonly => true,
    }

    if $expire_password {
        # force user to set password on first login
        exec { "chage -d 0 $user":
            path        => "/usr/bin",
            subscribe   => User[$user],
            refreshonly => true,
            require     => Exec["usermod --password '$password' $user"],
        }
    }

    # Where perl lives
    $export_path = "export PATH=${perlbin}:\$PATH"

    # Set up user
    file {
        # Copy the whole of the users bin dir
        "$path/$user/bin":
            ensure  => directory,
            require => User[$user],
            recurse => true,
            owner   => $user,
            group   => $user,
            mode    => '0700', # make everything executible
            source  => [
                    "puppet:///modules/sheep/default/$path/$user/bin",
                    "puppet:///modules/sheep/default/$path/default/bin",
            ];
    }->

    file {
        # .gitconfig
        "$path/$user/.gitconfig":
            require => User[$user],
            owner   => $user,
            group   => $user,
            mode    => '0600', # make everything executible
            source  => [
                    "puppet:///modules/sheep/default/$path/$user/.gitconfig",
            ];
    }->
    file {
        # .gitexclude
        "$path/$user/.gitexclude":
            require => User[$user],
            owner   => $user,
            group   => $user,
            mode    => '0600', # make everything executible
            source  => [
                    "puppet:///modules/sheep/default/$path/$user/.gitexclude",
            ];
    }->

    # Sort out ssh file, need dir first
    file{ "$path/$user/.ssh":
        owner  => $user,
        group  => $user,
        mode   => 0700,
        ensure => directory,
    }->
    file { "$path/$user/.ssh/authorized_keys":
        owner => $user,
        group => $user,
        mode  => 600,
        source => [
                "puppet:///modules/sheep/default/$path/$user/ssh/authorized_keys"
                ],
    }

    if($admin) {
        # Also add to sudoers
        file {
          "/etc/sudoers.d/$user":
            owner => "root",
            group => "root",
            mode => "440",
            content => "$user   ALL = ALL";
        }
    }
}


class sheep::user::admins {
    sheep::user {
        leo:
            admin    => true,
            fullname => "Leo Lapworth <leo@cuckoo.org>";
    }
}

