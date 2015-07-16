#!/bin/bash

echo $@

# For debug, Be loud about  whats going on
# set -o verbose
# Stop execution of this script if any error occurs.
set -e
# Echo executables for debugging / info

USAGE+=$'\n\t -e|--ci-environment Set environment variables on the CI docker container, e.g. -e PORTMAPS=8088:8088'
USAGE+=$'\n\t				Jenkins image expects the following environment variables:'
USAGE+=$'\n\t					-e PORTMAPS="8088:8088"'
USAGE+=$'\n\t					-e RESTPORT=4243'			
USAGE+=$'\n\t					-e GIT.URL=https://github.com/TopHackathon/example-app.git'
USAGE+=$'\n\t					-e IMAGETAGNAME=tophackathon/newapp'
USAGE+=$'\n\t --pull-first IMAGE		Force a pull of IMAGE '
USAGE+=$'\n\t -d|--docker-command COMMAND	Anything after the docker run command e.g. --docker-command "-d -p 8080:8080 tophackathon/ci-java8:1.3"'
USAGE+=$'\n\t -m|--machine-name MACHINE	Environment name.'
USAGE+=$'\n\t -m|--machine-name MACHINE	Environment name.'
USAGE+=$'\n\t --destroy-tie true|false Defaults to false If set to true, any existing MACHINE will be destroyed first.'
USAGE+=$'\n\t --destroy-container true|false Defaults to true If set to true, any existing CONTAINER on MACHINE with CONTAINER_NAME will be destroyed first.'
USAGE+=$'\n\t --docker-host-port The port you contact docker on. Defaults to 4243. e.g. docker -H IP:4243 ps'
USAGE+=$'\n'
USAGE+=$'\n\t outputs IP Ip of the machine/environment created for you'

function showHelp {
	echo $0 "creates a docker host and gives you back the IP of the host. A jenkins is created on the host, and the Jenkins builds a docker image, and launches it." 
	echo "You pass parameters to jenkins with -e|--ci-environment"
	echo ""
	echo "Usage: $0 $USAGE"
	echo ""
	echo "Example" $0 "my-machine \"run -e GIT.URL==https://github.com/TopHackathon/example-app.git -p 8080:8080 tophackathon/ci-java8:1.0\""
	echo "You can input any docker command you want. It will be executed on the newly created docker host."
}
if [ $# -eq 0 ]; then
	showHelp
	exit 1
fi

# Defaults 
DOCKER_HOST_PORT=4243
DESTROY_TIE=false
DESTROY_CONTAINER=true
CONTAINER_NAME=""
DOCKER_CONTAINER_NAME_PARAMETER_VALUE=""


while [[ $# > 0 ]]
do
	key="$1"
	
	case $key in
	    --help)
	    showHelp
	    exit 0
	    ;;
	    --container-name)
	    CONTAINER_NAME="$2"
	    DOCKER_CONTAINER_NAME_PARAMETER_VALUE="--name "
		DOCKER_CONTAINER_NAME_PARAMETER_VALUE+=$CONTAINER_NAME
	    
	    shift # past argument
	    ;;
	    -e|--ci-environment)
	    CI_ENVIRONMENT+="-e $2 "
	    shift # past argument
	    ;;
	    --destroy-tie)
	    DESTROY_TIE=$2
	    shift
	    ;;
	    --destroy-container)
	    DESTROY_CONTAINER=$2
	    shift
	    ;;
	    --pull-first)
	    PULL_FIRST="$2"
	    shift # past argument
	    ;;
	    --docker-host-port)
	    DOCKER_HOST_PORT="$2"
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

if [ "$DESTROY_TIE" = true ] ; then
	echo Destroying machine $MACHINE if it exists
	MACHINE=$MACHINE vagrant destroy --force
fi
echo Creating machine $MACHINE
MACHINE=$MACHINE vagrant up 

echo Querying machine for ip 
IP=$(MACHINE=$MACHINE vagrant ssh -c "ifconfig eth1" | grep "inet " | cut -f 2 -d ":" | cut -d " " -f 1)
echo "Machine with ip [$IP] created. Starting creation of CI (jenkins) environment."
CI_ENVIRONMENT+="-e MYIP=$IP "

if [ -n "$PULL_FIRST" ]; then
    docker -H $IP:$DOCKER_HOST_PORT pull $PULL_FIRST
fi

# If you want to destroy container and you provide a container name, 
if [ "$DESTROY_CONTAINER" = true ] && [ -n "$CONTAINER_NAME" ] ; then
	set +e
	if docker -H $IP:$DOCKER_HOST_PORT inspect -f '{{ .Name }}' $CONTAINER_NAME;
	then
		echo Stopping container $CONTAINER_NAME
		docker -H $IP:$DOCKER_HOST_PORT stop $CONTAINER_NAME
		echo Removing container $CONTAINER_NAME
		docker -H $IP:$DOCKER_HOST_PORT rm -v $CONTAINER_NAME
	fi
	set -e
fi

echo container name $CONTAINER_NAME
if [ "$DESTROY_CONTAINER" = true ] && [ -z "$CONTAINER_NAME" ] ; then
	echo If you want me to destroy the container, you have to provide a container name with container-name
	exit 1
fi


CONTAINER_ID=$(docker -H $IP:$DOCKER_HOST_PORT run $DOCKER_CONTAINER_NAME_PARAMETER_VALUE $CI_ENVIRONMENT $DOCKER_COMMAND)
CONTAINER_NAME=$(docker -H $IP:$DOCKER_HOST_PORT inspect -f '{{ .Name }}' $CONTAINER_ID)
CONTAINER_PORT=$(docker -H $IP:$DOCKER_HOST_PORT inspect --format='{{(index (index .NetworkSettings.Ports "8080/tcp") 0).HostPort}}' $CONTAINER_NAME)

echo Congratulation, you may now tie your tie on $IP 
echo Container id $CONTAINER_ID
out=${CONTAINER_NAME:1}
echo Container name $out
echo "http://"$IP:$CONTAINER_PORT

