#!/bin/bash

echo "Configuring  docker"

echo 'DOCKER_OPTS="-H=unix:///var/run/docker.sock -H=0.0.0.0:4243  --insecure-registry 192.168.1.24:5000"' >> /etc/default/docker
