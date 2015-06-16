#!/bin/bash

MACHINE=$1 vagrant destroy --force
MACHINE=$1 vagrant up
IP=$(MACHINE=$1 vagrant ssh -c 'ifconfig eth1 | grep "inet "' | grep "inet " | cut -f 2 -d ":" | cut -d " " -f 1)
docker -H $IP:4243 $2
echo Congratulation, you can tie your tie on $IP

