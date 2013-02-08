class sheep::web::imageeasel {
	nginx::vhost { "imageeasel.com":
		bare     => true,
		aliases => ["www.imageeasel.com", "$hostname.imageeasel.com"],
		client_max_body_size => '10',
	}

	nginx::proxy { "imageeasel.com":
		target   => "http://localhost:5002",
		vhost    => "imageeasel.com",
		location => "",
	}

	startserver { "www-imageeasel":
		root    => "/home/leo/git/www-imageeasel",
		perlbin => $perlbin,
        port    => 5002,
	}->
	service { "www-imageeasel":
		ensure => running,
		enable => true,
	}
}
