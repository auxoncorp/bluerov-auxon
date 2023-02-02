FROM rust:slim-bookworm as builder
RUN cargo install cargo-chef
RUN apt-get update && apt-get install -y pkg-config libssl-dev
RUN mkdir modality_ros_hook
WORKDIR /modality_ros_hook/
COPY /modality-ros2/modality_ros_hook/Cargo.toml .
COPY /modality-ros2/modality_ros_hook/Cargo.lock .
RUN cargo chef prepare --recipe-path recipe.json
RUN cargo chef cook --release --recipe-path recipe.json
RUN cargo chef cook --recipe-path recipe.json
COPY modality-ros2/modality_ros_hook/ .
RUN cargo build

FROM rezenders/ros-hackathon-humble
COPY --from=builder /modality_ros_hook/target/debug/libmodality_ros_hook.so /
COPY docker/bluerov/launch.sh /
COPY reflector-config.toml /
