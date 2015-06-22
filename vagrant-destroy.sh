#!/bin/bash

if [ $# -eq 0 ]; then
    echo "Usage: $0 machine-name [machine-name]"
    echo ""
    echo Destroys multiple vagrant machines. Convenience script to make it easy
    echo to call MACHINE=machine1 vagrant --force destroy
    echo         MACHINE=machine2 vagrant --force destroy
    echo ""
    echo "Example" $0 "machine1"
    echo ""
    exit 1
fi

for var in "$@"
do
    MACHINE=$var vagrant destroy --force
done
