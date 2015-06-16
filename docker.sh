#!/bin/bash

echo "installing docker"

DEVELOPER_ID=$1
echo adding [$DEVELOPER_ID] to docker group 

groupadd docker

sudo gpasswd -a $DEVELOPER_ID docker


sudo apt-get install curl -y
sudo curl -sSL https://get.docker.com/ubuntu/ | sudo sh

