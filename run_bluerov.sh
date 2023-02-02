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
echo "ros2 launch tudelft_hackathon bluerov_bringup.launch.py fcu_url:=udp://:14551@bluerov_sim:14555"

if [ -z "$CONTAINER_ID" ]; then
    container_name="bluerov"
    docker run \
        -it --rm \
        --net "$DOCKER_NETWORK" \
        --env MODALITY_AUTH_TOKEN \
        --env MODALITY_REFLECTOR_CONFIG="/reflector-config.toml" \
        --name "$container_name" \
        $CONTAINER_IMAGE \
        bash
else
    docker exec --privileged -e DISPLAY -it $CONTAINER_ID bash
fi

exit 0
