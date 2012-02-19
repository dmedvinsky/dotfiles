#!/usr/bin/env bash
path="~/.local/share/wallpapers/"
feh --bg-scale $path/$(ls $path/ | sort -R | tail -1)
