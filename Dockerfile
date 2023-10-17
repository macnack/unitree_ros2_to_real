FROM osrf/ros:humble-desktop-full

RUN apt-get update \
    && apt-get install -y --no-install-recommends \
    build-essential \
    cmake \
    git \
    libssl-dev \
    libusb-1.0-0-dev \
    pkg-config \
    libgtk-3-dev \
    libglfw3-dev \
    libgl1-mesa-dev \
    libglu1-mesa-dev \
    curl \
    python3 \
    python3-dev \
    ca-certificates \
    && rm -rf /var/lib/apt/lists/*


WORKDIR /root/ros2_ws/src
RUN git clone --branch fix/build https://github.com/macnack/unitree_ros2_to_real.git

RUN curl -L -o unitree_legged_sdk-3.5.1.tar.gz https://github.com/unitreerobotics/unitree_legged_sdk/archive/refs/tags/v3.5.1.tar.gz \
    && tar -xzvf unitree_legged_sdk-3.5.1.tar.gz \
    && mv unitree_legged_sdk-3.5.1 unitree_legged_sdk \
    && rm unitree_legged_sdk-3.5.1.tar.gz \
    && mv ./unitree_legged_sdk ./unitree_ros2_to_real/unitree_ros2_to_real/

RUN curl -L -o lcm-v1.5.0.tar.gz https://github.com/lcm-proj/lcm/archive/refs/tags/v1.5.0.tar.gz \
    && tar -xzvf lcm-v1.5.0.tar.gz \
    && rm lcm-v1.5.0.tar.gz \
    && cd lcm-1.5.0 \
    && mkdir build \
    && cd build \
    && cmake .. \
    && make install

WORKDIR /root/ros2_ws
RUN /bin/bash -c "source /opt/ros/humble/setup.bash; colcon build --symlink-install"

CMD ["bash"]