#!/usr/bin/env sh

swww query
if [ $? -eq 1 ] ; then
    swww init
fi
swww img ~/.config/hypr/monitor-left.gif --outputs HDMI-A-1
swww img ~/.config/hypr/monitor-right.png --outputs DP-2
