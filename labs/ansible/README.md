To run this lab we need to do the following steps:
1. generate ssh keys, run generate_ssh_keys.sh, keys will be stored locally in ~/.ssh/ansible_docker directory.
2. Run docker-compose up -d.
That's it.

So you're ready to do your ansible labs. What happens and what you can do inside containers
1. All needed hosts will be added to /etc/ansible/hosts
2. ssh_keys will be added inside containers.
3. working ssh access beetween ansible-controller and target1, target2 containers.
to access target1, target2 containers run the following command
ssh -i .ssh/ansible_docker ansible@172.16.0.3
and ssh -i .ssh/ansible_docker ansible@172.16.0.4
4. To test connection beetween ansible-controller and target1, target2 container run the following command
ansible all -m ping
You should get the success answer.
