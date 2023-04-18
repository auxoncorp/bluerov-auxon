# BlueROV2 Ignition Gazebo Sim

Based on the work from https://github.com/remaro-network/tudelft_hackathon.

## Getting Started

1. Build the images
  ```bash
  ./build_bluerov.sh
  ./build_sim.sh
  ```
2. Create a docker network
  ```bash
  docker network create ros_net
  ```
3. Run the simulation container, follow the printed instructions (run `/launch.sh`)
  ```bash
  ./run_sim.sh
  ```
4. Run the BlueROV2 container, follow the printed instructions (run `/launch.sh`)
  ```bash
  ./run_bluerov.sh
  ```
5. Record a ROS 2 bag from either images (or the host):
  ```bash
  ros2 bag record --all --output /tmp/logs
  ```
