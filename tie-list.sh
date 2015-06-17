#!/bin/bash

if [ $# -eq 0 ]; then
echo "Usage: $0 -> list of running images"
echo ""
echo $0 "creates a docker host and gives you back the IP of the host."
echo ""
echo "Example" $0 "my-machine run -e GIT.URL==https://github.com/TopHackathon/example-app.git -p 8080:8080 tophackathon/ci-java8:1.0"
echo ""
echo "You can input any docker command you want. It will be executed on the newly created docker host."
exit 1
fi

vagrant global-status
