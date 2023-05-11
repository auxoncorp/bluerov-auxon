#!/bin/bash

set -euo pipefail

export GZ_PARTITION="bluerov_sim:docker"

gz topic -e -n 1 -t /world/walls/model/bluerov2/link/base_link/sensor/bluerov2_contact/contact

exit 0
