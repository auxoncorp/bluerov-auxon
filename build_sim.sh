#!/bin/bash

set -euo pipefail

# TODO use https and main branch once public
if [ ! -d modality-ros2 ]; then
    git clone --depth 1 git@github.com:auxoncorp/modality-ros2.git
fi

# TODO use https and main branch once public
if [ ! -d modality-gazebo ]; then
    git clone --depth 1 git@github.com:auxoncorp/modality-gazebo.git
fi

docker build -f docker/sim/Dockerfile -t bluerov_sim .

exit 0
