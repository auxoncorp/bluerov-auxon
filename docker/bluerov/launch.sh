#!/bin/bash

set -euo pipefail

ros2 launch tudelft_hackathon bluerov_bringup.launch.py fcu_url:=udp://:14551@bluerov_sim:14555

exit 0
