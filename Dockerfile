# Start from debian
FROM debian:stretch-slim

# Copy in files
COPY ./entrypoint.sh /
COPY ./bash.bashrc /etc/bash.bashrc

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
RUN echo 'source /opt/ros/$ROS_DISTRO/setup.bash' >> /etc/bash.bashrc

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

# Install a window manager

# Install racecar code

# Start X, VNC and NoVNC
ENTRYPOINT ["/entrypoint.sh"]
