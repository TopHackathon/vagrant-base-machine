#!/bin/bash

if [ $# -eq 0 ]; then
echo "Usage: $0 machine-name \"docker-parameters-and-options\" -> IP"
echo ""
echo $0 "creates a docker host and gives you back the IP of the host."
echo ""
echo "Example" $0 "my-machine \"run -e GIT.URL==https://github.com/TopHackathon/example-app.git -p 8080:8080 tophackathon/ci-java8:1.0\""
echo ""
echo "You can input any docker command you want. It will be executed on the newly created docker host."
exit 1
fi

#Default
RUNTIME_RESTPORT=2376

while [[ $# > 0 ]]
do
key="$1"

case $key in
    -e|--ci-environment)
    CI_ENVIRONMENT+="-e $2 "
    shift # past argument
    ;;
    -p|--runtime-portmaps)
    RUNTIME_PORTMAPS="$2"
    shift # past argument
    ;;
    -r|--runtime-restport)
    RUNTIME_RESTPORT="$2"
    shift # past argument
    ;;
    -i|--runtime-imagename)
    RUNTIME_IMAGENAME="$2"
    shift # past argument
    ;;
    --pull-first)
    PULL_FIRST="$2"
    shift # past argument
    ;;
    -m|--machine-name)
    MACHINE="$2"
    shift # past argument
    ;;
    -d|--docker-command)
    DOCKER_COMMAND="$2"
    shift # past argument
    ;;
    *)
    echo "Unknown option $2"
    ;;
esac
shift # past argument or value
done

MACHINE=$MACHINE vagrant destroy --force
MACHINE=$MACHINE vagrant up
IP=$(MACHINE=$MACHINE vagrant ssh -c 'ifconfig eth1' | grep "inet " | cut -f 2 -d ":" | cut -d " " -f 1)
#docker -H $IP:4243 $ENVIRONMENT $2
if [ -n "$PULL_FIRST" ]; then
docker -H $IP:4243 pull $PULL_FIRST
fi
docker $CI_ENVIRONMENT -H $IP:4243 $DOCKER_COMMAND

echo Congratulation, you may now tie your tie on $IP

