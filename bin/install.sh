#!/bin/bash

DIR=$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )

# change to the ansible folder
cd $DIR/../data/ansible

# install roles from ansible galaxy we require
ansible-galaxy install -r requirements.yml -f

# finally install
ansible-playbook install.yml