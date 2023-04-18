#!/bin/bash

set -euo pipefail

docker build -f docker/bluerov/Dockerfile -t bluerov .

exit 0
