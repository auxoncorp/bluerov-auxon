#!/bin/bash

set -euo pipefail

export LD_PRELOAD=/libmodality_ros_hook.so:/opt/ros/humble/lib/librmw_fastrtps_cpp.so

ros2 launch tudelft_hackathon bluerov_bringup.launch.py fcu_url:=udp://:14551@bluerov_sim:14555

exit 0
