#!/usr/bin/env bash
layout=$($HOME/bin/xkb-switch -p)

if [ "$layout" = "us" ]; then
    color=gray
    bgcolor=
else
    color=white
    bgcolor=\#FF3636
fi

# xmobar
echo "<fc=$color,$bgcolor> $layout </fc>"
# awesome
echo "<span color=\"$color\" bgcolor=\"$bgcolor\"> $layout </span>"
