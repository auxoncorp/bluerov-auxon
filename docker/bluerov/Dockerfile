FROM rust:slim-bookworm as builder
RUN cargo install cargo-chef
RUN apt-get update && apt-get install -y pkg-config libssl-dev python3-pip
RUN pip3 install cython
RUN mkdir modality_ros_hook
WORKDIR /modality_ros_hook/
COPY /modality-ros2/modality_ros_hook/Cargo.toml .
COPY /modality-ros2/modality_ros_hook/Cargo.lock .
RUN cargo chef prepare --recipe-path recipe.json
RUN cargo chef cook --release --recipe-path recipe.json
RUN cargo chef cook --recipe-path recipe.json
COPY modality-ros2/modality_ros_hook/ .
RUN cargo build

# TODO fix the chef steps
RUN mkdir modality-sdk
WORKDIR /modality-sdk
COPY modality-sdk/ ./
WORKDIR /modality-sdk/client-libraries/c
ENV MODALITY_SDK_CAPI_OUT_DIR=/modality-sdk/client-libraries/c/target
RUN cargo build --release && ldconfig -N target/release && python3 setup.py build_ext --inplace

# TODO
# rust:slim-bookworm builds modality_sdk.cpython-311-x86_64-linux-gnu.so
# rezenders/ros-hackathon-humble builds modality_sdk.cpython-310-x86_64-linux-gnu.so
# we need 310 here
# language level fixes?
FROM rezenders/ros-hackathon-humble
RUN apt-get update && apt-get install -y vim less
RUN pip3 install cython
COPY --from=builder /modality_ros_hook/target/debug/libmodality_ros_hook.so /
COPY --from=builder /modality-sdk/client-libraries/c/modality_sdk*.so /modality-sdk/
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
RUN python3 setup.py build_ext --inplace
RUN cp modality_sdk.cpython*.so /modality-sdk
RUN mkdir /usr/lib/python3/dist-packages/modality_sdk/
RUN cp modality_sdk.cpython*.so /usr/lib/python3/dist-packages/modality_sdk/
RUN cp -a /modality-sdk/libmodality* /usr/lib/
WORKDIR /tudelft_hackathon_ws/
COPY docker/bluerov/launch.sh /
COPY reflector-config.toml /
COPY res/scripts/random_wall_avoidance.py /tudelft_hackathon_ws/src/tudelft_hackathon/scripts/random_wall_avoidance.py
