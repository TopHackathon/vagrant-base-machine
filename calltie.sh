#!/bin/bash

./tie-up.sh $1 "run -e GIT.URL=https://github.com/TopHackathon/example-app.git -p 8888:8080 -d tophackathon/ci-java8:1.0"

