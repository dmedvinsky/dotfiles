#!/usr/bin/env sh
count=$(/home/dmedvinsky/bin/gmail.check.sh)
if [ $count -ge 1 ]; then
    notify-send "Inbox: $count"
fi
