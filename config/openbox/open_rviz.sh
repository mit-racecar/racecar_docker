#!/usr/bin/env bash


source $HOME/racecar_ws/install/setup.bash
source /opt/ros/$ROS_DISTRO/setup.bash
exec /opt/ros/$ROS_DISTRO/bin/rviz2
