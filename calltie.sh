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
    ./tie-up.sh $var "run -e GIT.URL=https://github.com/TopHackathon/example-app.git -p 8888:8080 -d tophackathon/ci-java8:1.0"
done

