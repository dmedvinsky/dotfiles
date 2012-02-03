#!/bin/sh
curl https://mail.google.com/mail/feed/atom -n \
    | grep fullcount \
    | sed -re 's#^<fullcount>([0-9]+)</fullcount>$#\1#' \
    || exit 1
