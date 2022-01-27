# Start from debian
FROM debian:10.11-slim

# Update so we can download packages
RUN apt update

#Set the ROS distro
ENV ROS_DISTRO noetic

# Add the ROS keys and package
RUN apt install -y \
    lsb-release \
    curl \
    gnupg
RUN sh -c 'echo "deb http://packages.ros.org/ros/ubuntu $(lsb_release -sc) main" > /etc/apt/sources.list.d/ros-latest.list'
RUN curl -s "https://raw.githubusercontent.com/ros/rosdistro/master/ros.asc" | apt-key add -

# Install ROS
RUN apt update
RUN apt install -y \
    ros-$ROS_DISTRO-desktop \
    python3-rosdep

# Set up ROS
RUN rosdep init
RUN rosdep update

# Install VNC and things to install noVNC
RUN apt install -y \
    tigervnc-standalone-server \
    wget \
    git \
    unzip

# Download NoVNC and unpack
ENV NO_VNC_VERSION 1.3.0
RUN wget -q https://github.com/novnc/noVNC/archive/v$NO_VNC_VERSION.zip
RUN unzip v$NO_VNC_VERSION.zip
RUN rm v$NO_VNC_VERSION.zip
RUN git clone https://github.com/novnc/websockify /noVNC-$NO_VNC_VERSION/utils/websockify

# Install a window manager
RUN apt install -y \
    openbox \
    x11-xserver-utils \
    xterm \
    dbus-x11

# Install the racecar simulator
RUN apt install -y \
    ros-$ROS_DISTRO-tf2-geometry-msgs \
    ros-$ROS_DISTRO-ackermann-msgs \
    ros-$ROS_DISTRO-joy \
    ros-$ROS_DISTRO-map-server \
    build-essential
ENV SIM_WS /opt/ros/sim_ws
RUN mkdir -p $SIM_WS/src
RUN git clone https://github.com/mit-racecar/racecar_simulator.git
RUN mv racecar_simulator $SIM_WS/src
RUN /bin/bash -c 'source /opt/ros/$ROS_DISTRO/setup.bash; cd $SIM_WS; catkin_make;'

# Install some cool programs
RUN apt install -y \
    sudo \
    vim \
    nano \
    gedit \
    screen \
    tmux \
    locales \
    iputils-ping \
    feh \
    python3-numpy

# Set the locale
RUN echo "en_US.UTF-8 UTF-8" > /etc/locale.gen
RUN locale-gen

# Kill the bell!
RUN echo "set bell-style none" >> /etc/inputrc

# Creat a user
RUN useradd -ms /bin/bash racecar
RUN echo 'racecar:racecar@mit' | chpasswd
RUN adduser racecar sudo
USER racecar
WORKDIR /home/racecar

# Make a racecar workspace chained to the sim repo
RUN mkdir -p racecar_ws/src
RUN /bin/bash -c 'source $SIM_WS/devel/setup.bash; cd racecar_ws; catkin_make;'

# Copy UI files
COPY ./config/bash.bashrc .bashrc
COPY ./config/vimrc .vimrc
COPY ./config/Xresources .Xresources
COPY ./config/screenrc .screenrc
COPY ./config/default.rviz .rviz/
COPY ./config/openbox/* .config/openbox/

# Copy startup files
COPY ./entrypoint.sh .entrypoint.sh
COPY ./xstartup.sh .xstartup.sh
