#!/bin/bash -x

if (( $EUID != 0 )); then
    echo "Please run as root"
    exit
fi

# configure conjur CLI client
sudo echo $(netstat -rn | awk '/^0.0.0.0/ {print $2}') "conjur" >> /etc/hosts
CONJUR_CLI_PKG=conjur_5.4.0-1_amd64.deb
sudo dpkg -i /vagrant/$CONJUR_CLI_PKG
conjur init -h conjur
chown vagrant.vagrant ~/.netrc
curl -k https://conjur/health

export CONJURRC=~vagrant/.conjurrc

# below is a hack for the conjur helper methods
cp $CONJURRC /etc/conjur.conf
