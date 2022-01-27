#!/bin/bash

# Start the window manager
openbox > .log/openbox.log 2>&1 &

# Start the dock
plank > .log/plank.log 2>&1 &

# Merge in Xresources
xrdb -merge .Xresources

# Make keyboard repeat fast
xset r rate 150 30

# No beep
xset -b
