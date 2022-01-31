#!/bin/bash

# Set up ROS
/bin/bash -c 'source $SIM_WS/devel/setup.bash; cd racecar_ws; catkin_make;'
export ROS_IP=$(hostname -I)

# Start the VNC server
vncserver -SecurityTypes None -xstartup ./.xstartup.sh > .log/TigerVNC.log 2>&1

# Start NoVNC
exec /noVNC-$NO_VNC_VERSION/utils/novnc_proxy --vnc 0.0.0.0:5901 --listen 0.0.0.0:6080 > .log/NoVNC.log 2>&1 &

# Welcome message
printf "\n"
printf "~~~~~Welcome to the racecar docker image!~~~~~"
printf "\n\n"
printf "To interface via a local terminal, open a new"
printf "\n"
printf "terminal, cd into the racecar_docker directory"
printf "\n"
printf "and run:"
printf "\n\n"
printf "  docker-compose exec racecar bash"
printf "\n\n"
printf "To use graphical programs like rviz, navigate"
printf "\n"
printf "to:"
printf "\n\n"
printf "  http://localhost:6080/vnc.html?resize=remote"
printf "\n"

# Hang
tail -f
