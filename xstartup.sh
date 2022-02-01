#!/bin/bash

# Start the window manager
openbox > $HOME/.log/openbox.log 2>&1 &

# Merge in Xresources
xrdb -merge $HOME/.Xresources

# Make keyboard repeat fast
xset r rate 150 30

# No beep
xset -b
