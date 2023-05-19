#!/bin/bash

set -euo pipefail

# TODO use https and main branch once public
if [ ! -d modality-ros2 ]; then
    git clone --depth 1 git@github.com:auxoncorp/modality-ros2.git
fi
if [ ! -d modality-sdk ]; then
    git clone --depth 1 https://github.com/auxoncorp/modality-sdk.git --branch more-python
fi

docker build -f docker/bluerov/Dockerfile -t bluerov .

exit 0
