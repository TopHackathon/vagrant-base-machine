#!/bin/bash

echo "installing docker"

sudo apt-get install curl -y
sudo curl -sSL https://get.docker.com/ubuntu/ | sudo sh
echo 'DOCKER_OPTS="-H=unix:///var/run/docker.sock -H=0.0.0.0:4243"' >> /etc/default/docker

