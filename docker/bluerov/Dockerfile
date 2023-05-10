FROM rust:slim-bookworm as builder
RUN cargo install cargo-chef
RUN apt-get update && apt-get install -y pkg-config libssl-dev python3-pip
RUN pip3 install --break-system-packages cython
# TODO fix the chef recipe build
#RUN mkdir modality_ros_hook
#WORKDIR /modality_ros_hook/
#COPY /modality-ros2/modality_ros_hook/Cargo.toml .
#COPY /modality-ros2/modality_ros_hook/Cargo.lock .
#RUN cargo chef prepare --recipe-path recipe.json
#RUN cargo chef cook --release --recipe-path recipe.json
#RUN cargo chef cook --recipe-path recipe.json
#COPY modality-ros2/modality_ros_hook/ .
RUN mkdir modality-ros2
WORKDIR /modality-ros2
COPY modality-ros2/ .
WORKDIR /modality-ros2/modality_ros_hook
RUN cargo build --release

# TODO chef recipe for sdk
RUN mkdir modality-sdk
WORKDIR /modality-sdk
COPY modality-sdk/ ./
WORKDIR /modality-sdk/client-libraries/c
ENV MODALITY_SDK_CAPI_OUT_DIR=/modality-sdk/client-libraries/c/target
ENV MODALITY_SDK_CYTHON_OUT_DIR=/modality-sdk/client-libraries/c/target/cython
RUN cargo build --release
RUN ldconfig -N target/release
# TODO once sdk C and cython packaging is finished, we could build it all in the builder
# but for now the python wheel has to be built in the base image since
# it has a different python version than the builder
#WORKDIR /modality-sdk/client-libraries/c/cython
#RUN apt-get install -y python3.11-venv
#RUN pip3 install --break-system-packages build
#RUN python3 -m build --wheel

FROM rezenders/ros-hackathon-humble
RUN apt-get update && apt-get install -y vim less python3.10-venv
RUN pip3 install cython build
COPY --from=builder /modality-ros2/modality_ros_hook/target/release/libmodality_ros_hook.so /
COPY --from=builder /modality-sdk/client-libraries/c/target/release/libmodality.so /modality-sdk/
COPY --from=builder /modality-sdk/client-libraries/c/target/cython /modality-sdk/
COPY --from=builder /modality-sdk/client-libraries/c/target/include /modality-sdk/
RUN ldconfig -N /modality-sdk
WORKDIR /modality-sdk
RUN git clone --depth 1 https://github.com/auxoncorp/modality-sdk.git --branch more-python repo
WORKDIR /modality-sdk/repo/client-libraries/c
RUN mkdir -p target/release target/include target/cython
RUN cp -a /modality-sdk/modality target/include/
RUN cp -a /modality-sdk/modality.pyx target/cython
RUN cp -a /modality-sdk/libmodality* target/release/
ENV MODALITY_SDK_CAPI_OUT_DIR=/modality-sdk/repo/client-libraries/c/target
ENV MODALITY_SDK_CYTHON_OUT_DIR=/modality-sdk/repo/client-libraries/c/target/cython/
WORKDIR /modality-sdk/repo/client-libraries/c/cython
RUN python3 -m build --wheel
RUN cp dist/*.whl /modality-sdk/
RUN pip3 install /modality-sdk/modality_sdk-0.1-cp310-cp310-linux_x86_64.whl
RUN cp -a /modality-sdk/libmodality* /usr/lib/
WORKDIR /tudelft_hackathon_ws/
COPY docker/bluerov/launch.sh /
COPY docker/reflector-config.toml /
COPY res/scripts/random_wall_avoidance.py /tudelft_hackathon_ws/src/tudelft_hackathon/scripts/random_wall_avoidance.py
