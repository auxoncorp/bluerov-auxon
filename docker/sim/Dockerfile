FROM rezenders/ignition:hackathon-nvidia-humble

RUN sudo apt-get update
RUN sudo apt-get install -y gstreamer1.0-plugins-bad gstreamer1.0-libav gstreamer1.0-gl libqt5gui5 libfuse2 vim

RUN sudo wget -q -O /libmodality_ros_hook.so \
    https://github.com/auxoncorp/modality-ros2/releases/latest/download/libmodality_ros_hook_22.04_amd64.so

RUN sudo wget -q -O /opt/QGroundControl.AppImage https://s3.amazonaws.com/downloads.bluerobotics.com/QGC/latest/QGroundControl.AppImage
RUN sudo chmod +x /opt/QGroundControl.AppImage
RUN sudo mkdir -p /opt/QGroundControl
RUN sudo chmod 0755 /opt/QGroundControl
RUN cd /opt/QGroundControl && sudo /opt/QGroundControl.AppImage --appimage-extract
RUN sudo find /opt/QGroundControl -type d -print0 | sudo xargs -0 chmod 755
RUN sudo find /opt/QGroundControl -type f -print0 | sudo xargs -0 chmod 644
RUN cd /opt/QGroundControl/squashfs-root && sudo chmod 0755 QGroundControl qgroundcontrol-start.sh
RUN echo "#!/bin/bash\ncd /opt/QGroundControl/squashfs-root\n./qgroundcontrol-start.sh" > QGroundControl.sh
RUN sudo mv QGroundControl.sh /usr/local/bin/QGroundControl
RUN sudo chmod +x /usr/local/bin/QGroundControl

RUN sudo wget --no-verbose --quiet https://get.keygen.sh/auxon-io/auxon.deb -O auxon.deb
RUN sudo apt-get install -y ./auxon.deb
RUN sudo apt-get update
RUN sudo apt-get install -y libignition-gazebo7-dev libgz-cmake3-dev libignition-plugin-dev modality-sdk

RUN git clone --depth 1 https://github.com/auxoncorp/modality-gazebo.git /home/docker/tudelft_hackathon_ws/src/modality-gazebo
RUN mkdir -p /home/docker/tudelft_hackathon_ws/src/modality-gazebo/build
RUN cd /home/docker/tudelft_hackathon_ws/src/modality-gazebo/build && cmake .. && make

COPY ["res/bluerov2_ignition/models/bluerov2/model.sdf", "/home/docker/tudelft_hackathon_ws/src/bluerov2_ignition/models/bluerov2/model.sdf"]
COPY ["res/bluerov2_ignition/models/bluerov2_lidar/model.sdf", "/home/docker/tudelft_hackathon_ws/src/bluerov2_ignition/models/bluerov2_lidar/model.sdf"]
COPY ["res/remaro_worlds/models/Grey Wall/model.sdf", "/home/docker/tudelft_hackathon_ws/src/remaro_worlds/models/Grey Wall/model.sdf"]

RUN sudo chown -R docker:docker /home/docker/tudelft_hackathon_ws/src

COPY docker/sim/launch.sh /
COPY docker/reflector-config.toml /
