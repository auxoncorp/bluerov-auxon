#!/bin/bash

set -euo pipefail

export LD_PRELOAD=/libmodality_ros_hook.so:/opt/ros/humble/lib/librmw_fastrtps_cpp.so

ros2 launch tudelft_hackathon bluerov_ign_sim.launch.py ardusub:=true mavros_url:='bluerov:14551'

exit 0
