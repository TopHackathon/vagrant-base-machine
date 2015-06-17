#!/bin/bash

if [ $# -eq 0 ]; then
echo "Usage: $0 machine-name"
echo ""
echo $0 "Shuts down and destroys a previously created image. Image names can be found with tie-list"
echo ""
echo "Example" $0 "my-machine"
echo ""
exit 1
fi
MACHINE=$1 vagrant destroy --force
