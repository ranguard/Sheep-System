Puppet for ranguard
===================

Setup
------

# We want puppet from backports so...
    # Edit /etc/apt/sources.list add:
    deb http://backports.debian.org/debian-backports squeeze-backports main

    sudo apt-get update

    sudo apt-get -y install openssh-server git
    sudo apt-get -y -t squeeze-backports install puppetmaster puppet

    sudo apt-get install -y puppet git libp
    
    update-rc.d -n puppetmaster remove
    update-rc.d -n puppet remove
    update-rc.d -n puppetqd remove


How to use it
-------------

    
    mkdir /home/leo/git
    cd /home/leo/git
    git clone https://github.com/ranguard/Sheep-System.git ./sheep
    
    sudo puppet apply --modulepath=/home/leo/git/sheep/puppet/modules/ /home/leo/git/sheep/puppet/manifests/site.pp --verbose
    
