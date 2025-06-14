#!/bin/bash
sudo apt update -y
sudo apt upgrade -y
sudo apt -y install openjdk-21-jre
sudo apt -y install git unzip
# Install Terraform
sudo apt install  software-properties-common gnupg2 curl
curl https://apt.releases.hashicorp.com/gpg | gpg --dearmor > hashicorp.gpg
sudo install -o root -g root -m 644 hashicorp.gpg /etc/apt/trusted.gpg.d/
sudo apt-add-repository "deb [arch=$(dpkg --print-architecture)] https://apt.releases.hashicorp.com $(lsb_release -cs) main"
sudo apt install terraform
# Install AWS
curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"
unzip awscliv2.zip
sudo ./aws/install
# # Start and Enable Docker
# sudo systemctl start docker
# sudo systemctl enable docker
# Gives ec2-user and jenkins access to Jenkins
# sudo usermod -a -G docker jenkins
# sudo usermod -a -G docker ec2-user
# install ansible
