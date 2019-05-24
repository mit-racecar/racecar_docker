#!/bin/bash

# Make a logging directory
mkdir log

# Define the display
export DISPLAY=":2"

# Start the X server
Xvfb $DISPLAY -screen 0 1920x1080x16 > log/xvfb.log 2>&1 &

# Start the VNC server
x11vnc -many -display $DISPLAY -bg -nopw -repeat

# Start NoVNC
./noVNC-$NO_VNC_VERSION/utils/launch.sh --vnc localhost:5900 > log/NoVNC.log 2>&1 &

# Source ROS
source /racecar_ws/devel/setup.bash

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

# Start a bash shell
/bin/bash -c bash
