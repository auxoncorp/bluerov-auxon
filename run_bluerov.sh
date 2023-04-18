#!/bin/bash

set -euo pipefail

# Make sure 'ros_net' docker network exists
DOCKER_NETWORK="ros_net"
if ! docker network inspect "$DOCKER_NETWORK" &>/dev/null ; then
    echo "The docker network '$DOCKER_NETWORK' doesn't exist. Run 'docker network create $DOCKER_NETWORK' first."
    exit 1
fi

CONTAINER_IMAGE=${1:-bluerov}
CONTAINER_ID=$(docker ps -aqf "ancestor=${CONTAINER_IMAGE}")

echo "In the console, run this"
echo "/launch.sh"

if [ -z "$CONTAINER_ID" ]; then
    container_name="bluerov"
    docker run \
        -it --rm \
        --net "$DOCKER_NETWORK" \
        --name "$container_name" \
        $CONTAINER_IMAGE \
        bash
else
    docker exec --privileged -e DISPLAY -it $CONTAINER_ID bash
fi

exit 0
