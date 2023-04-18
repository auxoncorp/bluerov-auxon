FROM rezenders/ignition:hackathon-nvidia-humble

RUN sudo apt-get update
RUN sudo apt-get install -y ros-humble-ros2bag
RUN sudo apt-get install -y gstreamer1.0-plugins-bad gstreamer1.0-libav gstreamer1.0-gl libqt5gui5 libfuse2 vim

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

COPY ["res/bluerov2_ignition/models/bluerov2/model.sdf", "/home/docker/tudelft_hackathon_ws/src/bluerov2_ignition/models/bluerov2/model.sdf"]
COPY ["res/bluerov2_ignition/models/bluerov2_lidar/model.sdf", "/home/docker/tudelft_hackathon_ws/src/bluerov2_ignition/models/bluerov2_lidar/model.sdf"]
COPY ["res/remaro_worlds/models/Grey Wall/model.sdf", "/home/docker/tudelft_hackathon_ws/src/remaro_worlds/models/Grey Wall/model.sdf"]

RUN sudo chown -R docker:docker /home/docker/tudelft_hackathon_ws/src

COPY docker/sim/launch.sh /
