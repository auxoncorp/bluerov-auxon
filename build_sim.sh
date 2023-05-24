#!/bin/bash

set -euo pipefail

docker build -f docker/sim/Dockerfile -t bluerov_sim .

exit 0
