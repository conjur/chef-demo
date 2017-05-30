#!/bin/bash 
if (( $EUID != 0 )); then
    echo "Please run as root"
    exit
fi

pushd /root
apt-get install jq
# upgrade to latest chef dev kit - chef-client needs to be > v12.4
curl https://omnitruck.chef.io/install.sh | sudo bash -s -- -c current -P chefdk
chef-client -v

# setup the master chef repo
wget http://github.com/opscode/chef-repo/tarball/master
tar xvf master
rm master
mv chef-boneyard-chef-repo-605eeda /root/chef-repo
cd /root/chef-repo/
mkdir .chef
echo "cookbook_path ['/root/chef-repo/cookbooks']" > .chef/knife.rb

# download dependent cookbooks
cd /root/chef-repo/cookbooks

knife cookbook site download apache2
tar xvf apache2-3.3.0.tar.gz 
rm apache2-3.3.0.tar.gz 

knife cookbook site download apt
tar xvf apt-6.1.0.tar.gz 
rm apt-6.1.0.tar.gz 

knife cookbook site download iptables
tar xff iptables-4.2.0.tar.gz 
tar xvf iptables-4.2.0.tar.gz 
rm iptables-4.2.0.tar.gz 

knife cookbook site download logrotate
tar xvf logrotate-2.1.0.tar.gz 
rm logrotate-2.1.0.tar.gz 

knife supermarket download yum
tar xvf yum-5.0.1.tar.gz 
rm yum-5.0.1.tar.gz 

knife supermarket download sshd-service
tar xvf sshd-service-1.2.0.tar.gz 
rm sshd-service-1.2.0.tar.gz 

knife supermarket download conjur
tar xvf conjur-0.4.3.tar.gz 
rm conjur-0.4.3.tar.gz 

knife supermarket download conjur-host-identity
tar xvf conjur-host-identity-1.0.2.tar.gz 
rm conjur-host-identity-1.0.2.tar.gz 

#generate cookbook for app to build
chef generate cookbook phpapp
cd phpapp
cp /vagrant/etc/metadata.rb ./metadata.rb 
cp /vagrant/etc/default.rb ./recipes/default.rb 
cd /vagrant

# go back to directory containing this script 
popd

cp /vagrant/etc/solo.rb ./solo.rb 
cp /vagrant/etc/web.json ./web.json
./setup_conjur.sh
