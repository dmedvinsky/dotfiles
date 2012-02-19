#!/usr/bin/env sh
pidof stalonetray && killall stalonetray || exec stalonetray
