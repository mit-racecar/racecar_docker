# Make the prompt look cool
PS1='\[\e[1;31m\]\w~> \[\e[0;37m\]'


# Source ROS
source /opt/ros/foxy/setup.bash
source $HOME/racecar_ws/install/setup.bash
source $SIM_WS/install/setup.bash

# Go to the racecar_ws
cd $HOME/racecar_ws
