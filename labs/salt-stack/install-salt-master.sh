#!/bin/bash
#HOME = /root


#Install required packages
sudo add-apt-repository ppa:deadsnakes/ppa 
sudo apt-get update 
sudo apt-get install -y python3.7

#salt master provisioning
sudo curl -L https://bootstrap.saltstack.com -o install_salt.sh
sudo sh install_salt.sh -P -M -N

master=$(hostname -I)
sudo touch /etc/salt/master.d/local.conf
sudo echo "interface: $(hostname -I)" | sudo tee -a /etc/salt/master.d/local.conf
sudo systemctl restart salt-master

#sudo salt-key --finger-all
# I've faced the following issue - The Salt Master has cached the public key for this node, this salt minion will wait for 10 seconds before attempting to re-authenticate
# Solution: on salt-master
#1) delete minion1 key
#sudo salt-key -d minion1
# 2) accept minion1 key
# sudo salt-key -a minion1
# 3) verify that key was accepted
# sudo salt-key --finger-all
# Now minion1 key should be accepted

#Run test commands
# sudo salt minion1 test.ping
