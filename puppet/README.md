

apt-get install -y puppet git libpath-class-perl
git clone https://github.com/kablamo/puppet.git ~/code/puppet
puppet apply ~/code/puppet/manifests/site.pp --verbose