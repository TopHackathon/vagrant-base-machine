#!/bin/bash

if [ $# -ne 0 ]; then
	echo "Usage: $0 -> list of running images"
	echo ""
	exit 1
fi

vagrant global-status
