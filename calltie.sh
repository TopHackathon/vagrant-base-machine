#!/bin/bash

if [ $# -eq 0 ]; then
echo "Usage: $0 machine-name [machine-name]"
echo ""
echo $0 "is an example scripts that calls the main creation script for a virtual toolchain in Topdanmark Hackathon."
echo ""
echo "Example" $0 "my-machine"
echo ""
exit 1
fi

for var in "$@"
do
  ./tie-up.sh --machine-name $var \
  			  --container-name $var \
  								  -e PORTMAPS="8088:8080" -e RESTPORT=4243 \
  								  -e GIT.URL=https://github.com/TopHackathon/example-app.git \
  								  -e IMAGETAGNAME=tophackathon/newapp \
  								  --docker-command "-d -p 8080 tophackathon/ci-java8:1.3"
done

