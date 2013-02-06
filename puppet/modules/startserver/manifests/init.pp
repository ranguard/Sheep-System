define startserver(
	$perlbin,
	$filename = $name,
	$description = "Startup script for $name",
	$root,
	$workers = 5,
	$port = 5000,
	$user = 'www-data',
) {
    include startserver::environment

    file { "/etc/init.d/$filename":
        ensure => file,
        mode   => 0755,
        content => template("startserver/init.erb"),
    }
    
    # Some where for log files
    file { "/var/log/starman/$filename":
        ensure => directory,
        owner => $user,
        group => $user,
        mode => 0755,
    }
}
