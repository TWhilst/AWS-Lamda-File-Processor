#!/bin/bash
sudo apt update && upgrade -y
# Add Docker's official GPG key:
sudo apt-get update
sudo apt-get install ca-certificates curl
sudo install -m 0755 -d /etc/apt/keyrings
sudo curl -fsSL https://download.docker.com/linux/ubuntu/gpg -o /etc/apt/keyrings/docker.asc
sudo chmod a+r /etc/apt/keyrings/docker.asc

# Add the repository to Apt sources:
echo \
  "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.asc] https://download.docker.com/linux/ubuntu \
  $(. /etc/os-release && echo "${UBUNTU_CODENAME:-$VERSION_CODENAME}") stable" | \
  sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
sudo apt-get update
# Install Docker Engine, CLI, containerd, Buildx, and Compose:
sudo apt-get install docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin -y
sudo docker run hello-world
sudo systemctl enable docker.service
sudo systemctl enable containerd.service
sudo docker network create jenkins-network
sudo docker run -dt --name jenkins-master -p 8080:8080 -p 50000:50000 -v /var/run/docker.sock:/var/run/docker.sock -v $(which docker):/usr/bin/docker -v jenkins_home:/var/jenkins_home -u root -e DOCKER_GID=$(getent group docker | cut -d: -f3) --network jenkins-network jenkins/jenkins:lts
# Pull the Jenkins master
# port of jenkins master and agent
# mount the docker socket 
# mount the docker binary
# mount the home directory of jenkins
# set the user to root to avoid permission issues
# set the group id to the docker group
# the network to connect to
# the image to use
# sudo docker run -dt \
#     --name jenkins-master \
#     -p 8080:8080 -p 50000:50000 \
#     -v /var/run/docker.sock:/var/run/docker.sock \
#     -v $(which docker):/usr/bin/docker \
#     -v jenkins_home:/var/jenkins_home \
#     -u root \
#     -e DOCKER_GID=$(getent group docker | cut -d: -f3) \
#     --network jenkins-network \
#     jenkins/jenkins:lts
# sudo groupadd docker
# sudo usermod -aG docker $USER
# newgrp docker
# sudo reboot


