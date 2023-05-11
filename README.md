# BlueROV2 Ignition Gazebo Sim

Based on the work from https://github.com/remaro-network/tudelft_hackathon.

## Getting Started

1. Do initial setup (if needed)
  ```bash
  modality user create --use demo
  modality workspace create --use demo workspace.toml
  ```
1. Build the images
  ```bash
  ./build_bluerov.sh
  ./build_sim.sh
  ```
1. Create a docker network
  ```bash
  docker network create --subnet=172.18.0.1/24 ros_net
  ```
1. Ensure the [reflector-config.toml](./reflector-config.toml) URL matches your `modalityd` and docker networking
  ```bash
  # Add
  # --connect-addr '172.18.0.1:14182' --mutation-connect-addr '172.18.0.1:14192'
  #to the modalityd config or CLI invocation
  ```
1. Export your auth token
  ```bash
  export MODALITY_AUTH_TOKEN=$(< ~/.config/modality_cli/.user_auth_token)
  ```
1. Run the local reflector instance
  ```bash
  modality-reflector run --config reflector-config.toml
  ```
1. Run the simulation container, follow the printed instructions (run `/launch.sh`)
  ```bash
  ./run_sim.sh
  ```
1. Run the BlueROV2 container, follow the printed instructions (run `/launch.sh`)
  ```bash
  ./run_bluerov.sh
  ```

## Running the robot framework tests

```
sudo apt-get install -y python3-tk
pip install robotframework
```

```
robot system.robot
```
