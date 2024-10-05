#!/usr/bin/env sh

swww query
if [ $? -eq 1 ] ; then
    swww init
fi
swww img ~/.config/hypr/monitor-left.gif --outputs $(xrandr --query | grep HDMI | sed "s/ .*//")
swww img ~/.config/hypr/monitor-right.png --outputs $(xrandr --query | grep DP | sed "s/ .*//")
