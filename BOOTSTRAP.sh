#!/bin/bash

# Copyright 2017 Mark Burns
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#    http://www.apache.org/licenses/LICENSE-2.0
#
#    Unless required by applicable law or agreed to in writing, software
#    distributed under the License is distributed on an "AS IS" BASIS,
#    WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
#    See the License for the specific language governing permissions and
#    limitations under the License.

# @TODO Divvy up workload into functions, and add parameters to choose which bits to run.

# Help stuff?
if [ "$1" == "-h" ]
then
    echo "Version: 0.1 (c)
    Usage: `basename $0` [-h] -- Bootstraps local environment by installing Ansible and Git, and then calling the first in a chain of playbooks.
    
Ubuntu Edition.

These playbooks are used to install common, and useful, software and config on first use of a new system.
    
Where:
    -h    Show this help text"
    exit 0
fi

# Pre-processing...
echo "Update repo package lists..."
sudo apt update

# Install Ansible and Aptitude (needed by Ansible)
if [ "dpkg -l ansible != """ ]
then
    echo "Installing Ansible..."
    sudo apt install ansible aptitude
fi

# Install Git
if [ "dpkg -l git != """ ]
then
    echo "Installing Git..."
    sudo apt install git git-core git-doc git-cola
fi

# Generate SSH key
if [ ! -f ~/.ssh/id_rsa.pub ]
then
    echo "Generating an SSH key..."
    ssh-keygen -t rsa
fi

# Generate PGP key
if [ ! -f ~/.gnupg/pubring.gpg ]
then
    echo "Generating a GPG key..."
    gpg --gen-key
    wait
    gpg -k
fi

# Post-processing...
echo "Update Ansible hosts file..."
sudo su -c 'echo "localhost ansible_connection=local" >> /etc/ansible/hosts'
