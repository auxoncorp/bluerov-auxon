#!/bin/bash

set -euo pipefail

# Make sure 'ros_net' docker network exists
DOCKER_NETWORK="ros_net"
if ! docker network inspect "$DOCKER_NETWORK" &>/dev/null ; then
    echo "The docker network '$DOCKER_NETWORK' doesn't exist. Run 'docker network create $DOCKER_NETWORK' first."
    exit 1
fi

XAUTH=/tmp/.docker.xauth
if [ ! -f "$XAUTH" ]; then
    xauth_list=$(sed -e 's/^..../ffff/' <<< "$(xauth nlist $DISPLAY)")
    if [ ! -z "$xauth_list" ]; then
        echo "$xauth_list" | xauth -f "$XAUTH" nmerge -
    else
        touch "$XAUTH"
    fi
    chmod a+r "$XAUTH"
fi

DOCKER_OPTS=
DOCKER_VERSION=$(docker version --format '{{.Server.Version}}')
if dpkg --compare-versions 19.03 gt "$DOCKER_VERSION" ; then
    echo "Docker version is less than 19.03, using nvidia-docker2 runtime"
    if [ ! dpkg --list | grep nvidia-docker2 ]; then
        echo "Update docker to a version greater than 19.03 or install nvidia-docker2"
        exit 1
    fi
    DOCKER_OPTS="$DOCKER_OPTS --runtime=nvidia"
else
    DOCKER_OPTS="$DOCKER_OPTS --gpus all"
fi

CONTAINER_IMAGE=${1:-bluerov_sim}
CONTAINER_ID=$(docker ps -aqf "ancestor=${CONTAINER_IMAGE}")

echo "In the console, run this"
echo "/launch.sh"

if [ -z "$CONTAINER_ID" ]; then
    container_name="bluerov_sim"
    docker run \
        -it --rm \
        --net "$DOCKER_NETWORK" \
        --name "$container_name" \
        $DOCKER_OPTS \
        --env DISPLAY=$DISPLAY \
        --env XAUTHORITY="$XAUTH" \
        --env MODALITY_AUTH_TOKEN \
        --env MODALITY_REFLECTOR_CONFIG="/reflector-config.toml" \
        --volume=/tmp/.X11-unix:/tmp/.X11-unix:ro \
        --volume="$XAUTH:$XAUTH" \
        $CONTAINER_IMAGE \
        bash
else
    docker exec --privileged -e DISPLAY -it $CONTAINER_ID bash
fi

exit 0
