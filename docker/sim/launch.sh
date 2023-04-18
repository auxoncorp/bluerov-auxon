#!/bin/bash

set -euo pipefail

ros2 launch tudelft_hackathon bluerov_ign_sim.launch.py ardusub:=true mavros_url:='bluerov:14551'

exit 0
