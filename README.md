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
5. Record a ROS 2 bag from either container (or the host):
  ```bash
  ./run_bluerov.sh
  ```
  ```bash
  source "/opt/ros/humble/setup.bash"
  source "/tudelft_hackathon_ws/install/setup.bash"

  ros2 bag record --all
  ```
