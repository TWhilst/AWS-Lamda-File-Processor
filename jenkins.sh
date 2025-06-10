#!/bin/bash
sudo apt update -y
sudo apt upgrade -y
sudo wget -O /etc/apt/keyrings/jenkins-keyring.asc \
  https://pkg.jenkins.io/debian-stable/jenkins.io-2023.key
echo "deb [signed-by=/etc/apt/keyrings/jenkins-keyring.asc]" \
  https://pkg.jenkins.io/debian-stable binary/ | sudo tee \
  /etc/apt/sources.list.d/jenkins.list > /dev/null
sudo apt install fontconfig openjdk-21-jre -y
sudo apt-get update
sudo apt-get -y install jenkins
sudo apt update
sudo apt -y install fontconfig openjdk-21-jre
sudo systemctl daemon-reload
# Start and Enable Jenkins
sudo systemctl start jenkins
sudo systemctl enable jenkins
# Install Git and Docker
sudo apt -y install git