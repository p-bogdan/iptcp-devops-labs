#!/bin/bash
cd /tmp
#Install ansible and git
apt-get update && apt-get install -yq ansible=2.9.6* git
#Clone repo from Google Cloud Source Repositories and checkout to a specific branch
repo_name=bookshelf-p.bogdan

gcloud source repos clone $repo_name && cd $repo_name 
#&& git checkout -b gcp-lab


#Pull last changes
#git pull origin gcp-lab

#Get variables for ansible from Google Secret Manager
#export secret_version=`gcloud secrets versions list tf-ansible-vars --format='value(name)' --filter=state=ENABLED`
#gcloud secrets versions access $secret_version --secret="tf-ansible-vars" > /tmp/bookshelf-p.bogdan/ansible/tf_ansible_vars.yml

gcloud secrets versions access `gcloud secrets versions list tf-ansible-vars --format='value(name)' --filter=state=ENABLED` --secret="tf-ansible-vars" > /tmp/bookshelf-p.bogdan/ansible/tf_ansible_vars.yml

#Run ansible playbook
ansible-playbook ansible/playbook.yml
