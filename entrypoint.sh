#!/bin/bash

# Make a logging directory
mkdir .log

# Start the VNC server
vncserver -SecurityTypes None -xstartup ./.xstartup.sh > .log/TigerVNC.log 2>&1

# Start NoVNC
exec /noVNC-$NO_VNC_VERSION/utils/novnc_proxy --vnc 0.0.0.0:5901 --listen 0.0.0.0:6080 > .log/NoVNC.log 2>&1 &

# If the car number is set, set up ROS hostnames
if [ -n "$1" ]; then
  export CAR_NUMBER=$1
  echo "192.168.1.$CAR_NUMBER racecar" >> /etc/hosts
  export ROS_MASTER_URI=http://racecar:11311
  export ROS_IP=$(hostname -I | grep -o 192.168.1.[0-9]* | head -1)
  if [ -z "$ROS_IP" ]; then
    printf "You are not on the 192.168.1.* network!\n"
    printf "Are you connected to your car's router?\n\n"
  fi
fi

# Welcome message
printf "Welcome to the racecar docker image!"
printf "\n\n"
printf "To use graphical programs like rviz, navigate to"
printf "\n"
printf "http://localhost:6080/vnc.html?resize=remote"
printf "\n\n"
printf "For instructions on connecting to a racecar,\n"
printf "mounting a local drive, connecting to a joystick,\n"
printf "etc. reference /README.md\n"

# Hang
tail -f
