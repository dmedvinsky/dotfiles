#!/usr/bin/env sh
layout=`$HOME/bin/xkb-switch -p`

if [ "$layout" = "us" ]; then
    color='gray'
    bgcolor=
else
    color=white
    bgcolor='#FF3636'
fi

echo "<fc=$color,$bgcolor> $layout </fc>"
