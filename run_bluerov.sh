#!/bin/bash

set -euo pipefail

# Make sure 'ros_net' docker network exists
DOCKER_NETWORK="ros_net"
if ! docker network inspect "$DOCKER_NETWORK" &>/dev/null ; then
    echo "The docker network '$DOCKER_NETWORK' doesn't exist. Run 'docker network create $DOCKER_NETWORK' first."
    exit 1
fi

DOCKER_OPTS="${DOCKER_OPTS:-"-it"}"
CONTAINER_IMAGE="bluerov"
CONTAINER_ID=$(docker ps -aqf "ancestor=${CONTAINER_IMAGE}")
CMD=${1:-bash}

echo "In the console, run this"
echo "/launch.sh"

if [ -z "$CONTAINER_ID" ]; then
    container_name="bluerov"
    docker run \
        --rm \
        $DOCKER_OPTS \
        --net "$DOCKER_NETWORK" \
        --hostname "bluerov" \
        --env MODALITY_AUTH_TOKEN \
        --env MODALITY_REFLECTOR_CONFIG="/reflector-config.toml" \
        --name "$container_name" \
        $CONTAINER_IMAGE \
        ${CMD}
else
    docker exec --privileged -e DISPLAY -it $CONTAINER_ID bash
fi

exit 0
