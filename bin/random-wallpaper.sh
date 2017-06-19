#!/usr/bin/env bash
wallpapers="/data/dmedvinsky/pic/wallpapers"
wallpaper="$wallpapers/$(ls $wallpapers/ | sort -R | tail -1)"
DISPLAY=:0 feh --bg-scale "$wallpaper"
