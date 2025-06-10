#!/bin/bash
sudo apt update -y
sudo apt upgrade -y
sudo apt install java-21 -y
sudo apt -y install git
# Install Terraform
sudo apt install  software-properties-common gnupg2 curl
curl https://apt.releases.hashicorp.com/gpg | gpg --dearmor > hashicorp.gpg
sudo install -o root -g root -m 644 hashicorp.gpg /etc/apt/trusted.gpg.d/
sudo apt-add-repository "deb [arch=$(dpkg --print-architecture)] https://apt.releases.hashicorp.com $(lsb_release -cs) main"
sudo apt install terraform
# Install AWS
sudo apt-get update
sudo apt-get install python3-pip
sudo pip install awscli
# # Start and Enable Docker
# sudo systemctl start docker
# sudo systemctl enable docker
# Gives ec2-user and jenkins access to Jenkins
# sudo usermod -a -G docker jenkins
# sudo usermod -a -G docker ec2-user
# install ansible
