#!/bin/bash

MACHINE=$1 vagrant halt
MACHINE=$1 vagrant up
# IP = get IP
IP=10.10.1.116
docker -H $IP:4243 $2

