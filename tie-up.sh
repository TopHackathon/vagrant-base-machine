#!/bin/bash

# Stop executin of this script if any error occurs.
set -e
# Echo executables for debugging / info
set -o verbose

USAGE+=$'\n\t-e|--ci-environment		Set environment variables on the CI docker container, e.g. -e PORTMAPS=8088:8088'
USAGE+=$'\n\t				Jenkins image expects the following environment variables:'
USAGE+=$'\n\t					-e PORTMAPS="8088:8088"'
USAGE+=$'\n\t					-e RESTPORT=4243'			
USAGE+=$'\n\t					-e GIT.URL=https://github.com/TopHackathon/example-app.git'
USAGE+=$'\n\t					-e IMAGETAGNAME=tophackathon/newapp'
USAGE+=$'\n\t--pull-first IMAGE		Force a pull of IMAGE '
USAGE+=$'\n\t-d|--docker-command COMMAND	Anything after the docker command e.g. --docker-command "run -d -p 8080:8080 tophackathon/ci-java8:1.3"'
USAGE+=$'\n\t-m|--machine-name MACHINE	Environment name.'
USAGE+=$'\n'
USAGE+=$'\n\t-> IP Ip of the machine/environment created for you'

if [ $# -eq 0 ]; then
	echo $0 "creates a docker host and gives you back the IP of the host. A jenkins is created on the host, and the Jenkins builds a docker image, and launches it." 
	echo "You pass parameters to jenkins with -e|--ci-environment"
	echo ""
	echo "Usage: $0 $USAGE"
	echo ""
	echo "Example" $0 "my-machine \"run -e GIT.URL==https://github.com/TopHackathon/example-app.git -p 8080:8080 tophackathon/ci-java8:1.0\""
	echo "You can input any docker command you want. It will be executed on the newly created docker host."
	exit 1
fi

while [[ $# > 0 ]]
do
	key="$1"
	
	case $key in
	    -e|--ci-environment)
	    CI_ENVIRONMENT+="-e $2 "
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

echo recreating machine $MACHINE
MACHINE=$MACHINE vagrant destroy --force
MACHINE=$MACHINE vagrant up --debug
echo Querying machine for 
IP=$(MACHINE=$MACHINE vagrant ssh -c 'ifconfig eth1' | grep "inet " | cut -f 2 -d ":" | cut -d " " -f 1)
echo "Machine with ip [$IP] created, starting docker configuration."
CI_ENVIRONMENT+="-e MYIP=$IP "

if [ -n "$PULL_FIRST" ]; then
    docker -H $IP:4243 pull $PULL_FIRST
fi
docker $CI_ENVIRONMENT -H $IP:4243 $DOCKER_COMMAND

echo Congratulation, you may now tie your tie on $IP
