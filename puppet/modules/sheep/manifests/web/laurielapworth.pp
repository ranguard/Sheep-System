class sheep::web::laurielapworth {
	nginx::vhost { "laurielapworth.com":
		bare     => true,
		aliases => ["www.laurielapworth.com", "$hostname.laurielapworth.com"],
	}

	nginx::proxy { "laurielapworth.com":
		target   => "http://localhost:5001",
		vhost    => "laurielapworth.com",
		location => "",
	}

	startserver { "www-laurielapworth":
		root    => "/home/leo/git/photoweb",
		perlbin => $perlbin,
        port    => 5001,
	}->
	service { "www-laurielapworth":
		ensure => running,
		enable => true,
	}
}
