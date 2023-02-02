#!/bin/bash

set -euo pipefail

# TODO use https and main branch once public
if [ ! -d modality-ros2 ]; then
    git clone --depth 1 git@github.com:auxoncorp/modality-ros2.git --branch humble
fi

docker build -f docker/bluerov/Dockerfile -t bluerov .

exit 0
