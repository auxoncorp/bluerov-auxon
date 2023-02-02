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
3. Ensure the [reflector-config.toml](./reflector-config.toml) URL matches your `modalityd` and docker networking
4. Export your auth token
  ```bash
  export MODALITY_AUTH_TOKEN="..."
  ```
5. Run the simulation container, follow the printed instructions (run `/launch.sh`)
  ```bash
  ./run_sim.sh 
  ```
6. Run the BlueROV2 container, follow the printed instructions (run `/launch.sh`)
  ```bash
  ./run_bluerov.sh
  ```
