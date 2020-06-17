#!/usr/bin/env bash

sudo apt-get update -y

echo "add docker key"
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -

sudo apt install docker-ce

echo "Add the Docker repository to APT sources"
sudo add-apt-repository --yes "deb [arch=amd64] https://download.docker.com/linux/ubuntu bionic stable"

echo "updating repos"
sudo apt-get update -y

echo "Install Java JDK"
sudo apt install default-jdk-headless -y 

echo "Install Docker engine"
sudo apt install docker-ce docker-ce-cli containerd.io -y
sudo systemctl enable docker

echo "Install kubectl"
curl -LO https://storage.googleapis.com/kubernetes-release/release/`curl -s https://storage.googleapis.com/kubernetes-release/release/stable.txt`/bin/linux/amd64/kubectl
chmod +x ./kubectl
sudo mv ./kubectl /usr/local/bin/kubectl
kubectl version --client

echo "Install Helm"
curl -fsSL -o get_helm.sh https://raw.githubusercontent.com/helm/helm/master/scripts/get-helm-3
chmod 700 get_helm.sh
./get_helm.sh

echo "Install Jenkins"
wget -q -O - https://pkg.jenkins.io/debian/jenkins.io.key | sudo apt-key add -
echo deb https://pkg.jenkins.io/debian-stable binary/ | sudo tee /etc/apt/sources.list.d/jenkins.list
sudo apt-get update -y
sudo apt-get install jenkins -y
sudo apt-key adv --keyserver keyserver.ubuntu.com --recv-keys 9B7D32F2D50582E6
sudo apt update
sudo apt-get install jenkins -y
sudo systemctl start jenkins
sudo ufw default deny incoming
sudo ufw default allow outgoing
sudo ufw allow ssh
sudo ufw allow 8080
echo "y" | sudo ufw enable

sudo usermod -aG docker jenkins

sudo systemctl restart jenkins
echo "Master Password"
sudo cat /var/lib/jenkins/secrets/initialAdminPassword