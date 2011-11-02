#!/bin/sh
cmd=$1
name=$2
noterm=$3
[ -z "$name" ] && name="$cmd"
[ "$noterm" = "no-term" ] && noterm=true || noterm=

tmux start-server 2>/dev/null
tmux list-sessions | grep $name || tmux new-session -d -s "$name" "$cmd"

[ -z "$noterm" ] && urxvtc -name $name -e tmux attach-session -t $name
