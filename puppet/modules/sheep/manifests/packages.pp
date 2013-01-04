class sheep::packages {
	# Editors
	package { vim: ensure => present }

	# System Tools
	package { curl: ensure => present }
	package { wget: ensure => present }
	package { lynx: ensure => present }
	package { mtr: ensure => present }
	package { bzip2: ensure => present }
	package { diffutils: ensure => present }

    package { htop: ensure => present }
    package { psmisc: ensure => present } # killall pstree fuser commands
    package { rsync: ensure => present }
    package { locate: ensure => present }


    # ensure locate actually works after install
    # comment this out to save a few seconds on initial install
    exec { "initialize-locate-db":
        command     => "updatedb",
        path        => "/usr/bin/",
        subscribe   => Package["locate"],
        refreshonly => true,
    }

    package { less: ensure => present }
    package { sysstat: ensure => present }
    package { ack-grep: ensure => present }
    package { tree: ensure => present }
    package { dnsutils: ensure => present }
    package { ntp: ensure => present }

    package { 'ca-certificates': ensure => latest }

    package { iproute: ensure => latest }
    package { 'iputils-ping': ensure => latest }

    package { libcairo2: ensure => latest }

    package { libexpat1: ensure => latest }
    package { 'libfont-freetype-perl': ensure => latest }
    package { libncurses5: ensure => latest }

    package { 'libpng12-0': ensure => latest }
    package { libxml2: ensure => latest }
    package { 'libxml2-utils': ensure => latest }
    package { memcached: ensure => latest }
    package { ncftp: ensure => latest }
    package { 'ncurses-base': ensure => latest }
    package { 'ncurses-bin': ensure => latest }
    package { nmap: ensure => latest }
    package { ntpdate: ensure => latest }
    package { rsyslog: ensure => latest }
    package { screen: ensure => latest }
    package { sudo: ensure => latest }
    package { varnish: ensure => latest }
    package { whiptail: ensure => latest }
    package { whois: ensure => latest }
    package { 'xml-core': ensure => latest }

    # package { exim: ensure => present } # TODO: FIX

    # Stuff for firewall / security
    package { iptables: ensure => installed }
    package { chkrootkit: ensure => present }

    # Euuu - nasty, remove
    package { nano: ensure => absent }
    package{ build-essential: ensure => present }

    case $operatingsystem {
      Debian: {
      }
      default: {
        Package{ provider => apt }
      }
    }
}




