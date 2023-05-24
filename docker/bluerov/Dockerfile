FROM rust:slim-bookworm as builder
RUN apt-get update && apt-get install -y --no-install-recommends pkg-config libssl-dev git
RUN git clone --depth 1 https://github.com/auxoncorp/modality-sdk.git --branch more-python /modality-sdk
WORKDIR /modality-sdk/client-libraries/c
ENV MODALITY_SDK_CAPI_OUT_DIR=/modality-sdk/client-libraries/c/target
ENV MODALITY_SDK_CYTHON_OUT_DIR=/modality-sdk/client-libraries/c/target/cython
RUN cargo build --release
RUN mkdir -p target/lib
RUN mv target/release/libmodality* target/lib/
RUN rm -rf target/release ../rust ../python
RUN mkdir -p target/release && mv target/lib/* target/release/
RUN ldconfig -N target/release
WORKDIR /
RUN tar czf modality-sdk.tar.gz modality-sdk/*

FROM rezenders/ros-hackathon-humble
RUN apt-get update && apt-get install -y vim less python3.10-venv
RUN pip3 install cython build
RUN wget -q -O /libmodality_ros_hook.so \
    https://github.com/auxoncorp/modality-ros2/releases/latest/download/libmodality_ros_hook_22.04_amd64.so
COPY --from=builder /modality-sdk.tar.gz /
RUN tar xf /modality-sdk.tar.gz -C /
ENV MODALITY_SDK_CAPI_OUT_DIR=/modality-sdk/client-libraries/c/target
ENV MODALITY_SDK_CYTHON_OUT_DIR=/modality-sdk/client-libraries/c/target/cython/
RUN cp -a /modality-sdk/client-libraries/c/target/release/libmodality* /usr/lib/
WORKDIR /modality-sdk/client-libraries/c/cython
RUN python3 -m build --wheel
RUN pip3 install dist/modality_sdk-0.1-cp310-cp310-linux_x86_64.whl

WORKDIR /tudelft_hackathon_ws/
COPY docker/bluerov/launch.sh /
COPY docker/reflector-config.toml /
COPY res/scripts/random_wall_avoidance.py /tudelft_hackathon_ws/src/tudelft_hackathon/scripts/random_wall_avoidance.py
