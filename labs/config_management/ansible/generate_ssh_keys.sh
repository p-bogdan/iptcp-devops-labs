#!/bin/sh
ssh-keygen -t rsa -b 4096 -f ~/.ssh/ansible_docker -q -N ""
