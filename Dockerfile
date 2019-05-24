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
RUN git clone https://github.com/novnc/websockify /noVNC-$NO_VNC_VERSION/utils/websockify

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
ENV SIM_WS /opt/ros/sim_ws
RUN mkdir -p $SIM_WS/src
RUN git clone https://github.com/mit-racecar/racecar_simulator.git
RUN mv racecar_simulator $SIM_WS/src
RUN /bin/bash -c 'source /opt/ros/$ROS_DISTRO/setup.bash; cd $SIM_WS; catkin_make;'

# Make a racecar workspace chained to the sim repo
RUN mkdir -p /racecar_ws/src
RUN /bin/bash -c 'source $SIM_WS/devel/setup.bash; cd racecar_ws; catkin_make;'

# Install some cool programs
RUN DEBIAN_FRONTEND=noninteractive \
    apt-get install -y \
    vim \
    nano \
    gedit \
    xterm \
    screen \
    tmux \
    locales
RUN echo "en_US.UTF-8 UTF-8" > /etc/locale.gen
RUN locale-gen

# Install a window manager
RUN DEBIAN_FRONTEND=noninteractive \
    apt-get install -y \
    openbox \
    feh \
    x11-xserver-utils \
    plank \
    dbus-x11

# Kill the bell!
RUN echo "set bell-style none" >> /etc/inputrc

# Copy in config files
COPY ./config/bash.bashrc /etc/
COPY ./config/vimrc /root/.vimrc
COPY ./config/Xresources /root/.Xresources
COPY ./config/screenrc /etc/
COPY ./config/racecar.jpg /root/
COPY ./config/default.rviz /root/.rviz/
ENV PLANK_FOLDER /root/.config/plank/dock1/launchers
RUN mkdir -p $PLANK_FOLDER
COPY ./config/plank/* $PLANK_FOLDER/
COPY ./entrypoint.sh /

# Start X, VNC and NoVNC
ENTRYPOINT ["/entrypoint.sh"]
