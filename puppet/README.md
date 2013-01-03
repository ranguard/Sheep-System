

apt-get install -y puppet git libpath-class-perl
git clone https://github.com/ranguard/Sheep-System.git /tmp/puppet
puppet apply --modulepath=/tmp/puppet/puppet/modules/ /tmp/puppet/puppet/manifests/site.pp --verbose