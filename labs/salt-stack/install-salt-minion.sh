#!/bin/bash
#HOME = /root

#Install required packages
sudo add-apt-repository ppa:deadsnakes/ppa 
sudo apt-get update 
sudo apt-get install -y python3.7

#salt minion
curl -L https://bootstrap.saltstack.com -o install_salt.sh
sudo sh install_salt.sh -P

sudo touch /etc/salt/minion.d/local.conf
#sudo echo "interface: ${local.vars}" | sudo tee -a /etc/salt/minion.d/local.conf
salt_master=$(gcloud compute instances list --format="value(networkInterfaces[0].networkIP)" --filter="name=('salt-master')")
sudo echo "interface: $salt_master" | sudo tee -a /etc/salt/minion.d/local.conf
sudo echo "id: minion1" | sudo tee -a /etc/salt/minion
sudo echo "$salt_master salt" | sudo tee -a /etc/hosts
#Run command from salt-master to get fingerprint and save it to /etc/salt/minion
gcloud compute ssh --zone us-west1-b iptcp@salt-master --quiet -- 'sudo salt-key -f master.pub' |sudo tee -a /tmp/test.log
fingerprint=$(sudo sed -n 's/.*master.pub: *//p' /tmp/test.log)
sudo echo "master_finger: '$fingerprint'" | sudo tee -a /etc/salt/minion
sudo chown -R salt:salt /etc/salt
sudo systemctl restart salt-minion

