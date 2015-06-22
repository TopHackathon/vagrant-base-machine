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
    ./tie-up.sh --machine-name $var -e PORTMAPS="8088:8088" -e RESTPORT=2376 -e GIT.URL=https://github.com/TopHackathon/example-app.git -e IMAGETAGNAME=tophackathon/newapp --docker-command "run -d -p 8080:8080 tophackathon/ci-java8:1.1"
#    ./tie-up.sh $var "run -e GIT.URL=https://github.com/TopHackathon/example-app.git -p 8888:8080 -d tophackathon/ci-java8:1.0"
#    ./tie-up.sh $var -p 8088:8088 -e RESTPORT=2376 -e GIT.URL=https://github.com/TopHackathon/example-app.git -e IMAGETAGNAME=tophackathon/newapp
done

