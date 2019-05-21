# Start from debian
FROM debian:stretch-slim

# Update so we can download packages
RUN apt-get update

#Set the ROS distro
ENV ROS_DISTRO melodic

# Add the ROS keys and package
RUN DEBIAN_FRONTEND=noninteractive \
    apt-get install -y \
    lsb-release \
    gnupg
RUN sh -c 'echo "deb http://packages.ros.org/ros/ubuntu $(lsb_release -sc) main" > /etc/apt/sources.list.d/ros-latest.list'
RUN mkdir ~/.gnupg
RUN echo "disable-ipv6" >> ~/.gnupg/dirmngr.conf
RUN apt-key adv --keyserver hkp://ha.pool.sks-keyservers.net:80 --recv-key 421C365BD9FF1F717815A3895523BAEEB01FA116

# Install ROS
RUN apt-get update
RUN apt-get install -y ros-melodic-desktop

# Set up ROS
RUN rosdep init
RUN rosdep update

# Install X server and VNC
RUN DEBIAN_FRONTEND=noninteractive \
    apt-get install -y \
    xvfb \
    x11vnc

# Expose the VNC port
EXPOSE 5900

# Install dependencies for NoVNC
RUN DEBIAN_FRONTEND=noninteractive \
    apt-get install -y \
    wget \
    unzip \
    git \
    procps \
    python \
    python-numpy

# Download NoVNC and unpack
ENV NO_VNC_VERSION 1.1.0
RUN wget -q https://github.com/novnc/noVNC/archive/v$NO_VNC_VERSION.zip
RUN unzip v$NO_VNC_VERSION.zip
RUN rm v$NO_VNC_VERSION.zip

# Expose the NoVNC port
EXPOSE 6080

# Install the racecar simulator
RUN DEBIAN_FRONTEND=noninteractive \
    apt-get install -y \
    ros-melodic-tf2-geometry-msgs \
    ros-melodic-ackermann-msgs \
    ros-melodic-joy \
    ros-melodic-map-server \
    build-essential
RUN mkdir -p /racecar_ws/src
RUN git clone https://github.com/mit-racecar/racecar_simulator.git
RUN mv racecar_simulator /racecar_ws/src
RUN /bin/bash -c 'source /opt/ros/$ROS_DISTRO/setup.bash; cd racecar_ws; catkin_make; catkin_make install'

# Install some cool programs
RUN DEBIAN_FRONTEND=noninteractive \
    apt-get install -y \
    vim \
    nano \
    gedit \
    xterm \
    screen \
    tmux

# Install a window manager
RUN DEBIAN_FRONTEND=noninteractive \
    apt-get install -y \
    openbox \
    feh \
    x11-xserver-utils

# Kill the bell!
RUN echo "set bell-style none" >> /etc/inputrc

# Copy in files
COPY ./bash.bashrc /etc/bash.bashrc
COPY ./vimrc /root/.vimrc
COPY ./Xresources /root/.Xresources
COPY ./racecar.jpg /root/racecar.jpg
COPY ./entrypoint.sh /

# Start X, VNC and NoVNC
ENTRYPOINT ["/entrypoint.sh"]
