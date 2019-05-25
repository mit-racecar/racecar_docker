#!/bin/bash

# Make a logging directory
mkdir log

# Define the display
export DISPLAY=":2"

# Start the X server
Xvfb $DISPLAY -screen 0 1920x1080x16 > log/xvfb.log 2>&1 &

# Start the VNC server
x11vnc -many -display $DISPLAY -bg -nopw -repeat > log/x11vnc.log 2>&1

# Start NoVNC
./noVNC-$NO_VNC_VERSION/utils/launch.sh --vnc localhost:5900 > log/NoVNC.log 2>&1 &

# Source ROS
source /racecar_ws/devel/setup.bash

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

# Start the window manager
openbox > log/openbox.log 2>&1 &

# Start the dock
plank > log/plank.log 2>&1 &

# Merge in Xresources
xrdb -merge /root/.Xresources

# Make keyboard repeat fast
xset r rate 150 30

# No beep
xset -b

# Add the background
feh --bg-scale /root/racecar.jpg

# Welcome message
IP=$(hostname -I | grep -o [0-9.]* | head -1)
printf "Welcome to the racecar docker image!"
printf "\n\n"
printf "To use graphical programs like rviz, navigate to"
printf "\n"
printf "http://$IP:6080/vnc.html"
printf "\n\n"
printf "Alternatively, point any VNC client to"
printf "\n"
printf "$IP:5900"
printf "\n\n"
printf "For instructions on connecting to a racecar,\n"
printf "mounting a local drive, connecting to a joystick,\n"
printf "etc. reference /README.md\n"

# Start a bash shell
/bin/bash -c bash
