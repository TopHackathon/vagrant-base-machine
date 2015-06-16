#!/bin/bash

MACHINE=$1 vagrant destroy --force
MACHINE=$1 vagrant up
# IP = get IP
IP=$(vagrant ssh $1 -c 'ifconfig eth1 | grep "inet "' | grep "inet " | cut -f 2 -d ":" | cut -d " " -f 1)
docker -H $IP:4243 $2

