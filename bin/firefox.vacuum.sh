#!/usr/bin/env sh
find ~/.mozilla/firefox/ -name *.sqlite -print -exec sqlite3 {} VACUUM \;
