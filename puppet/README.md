Puppet for ranguard
===================

How to use it
-------------

    sudo apt-get install -y puppet git libpath-class-perl
    
    mkdir /home/leo/git
    cd /home/leo/git
    git clone https://github.com/ranguard/Sheep-System.git ./sheep
    
    sudo puppet apply --modulepath=/home/leo/git/sheep/puppet/modules/ /home/leo/git/sheep/puppet/manifests/site.pp --verbose
    
