#!/usr/bin/env bash
tmpdir="/tmp/mutt_attach"
open_with=$1
path=$2
filename=$(basename "${path}")
newpath="$tmpdir/$filename"

mkdir -p "${tmpdir}"
rm -f "${tmpdir}/*"
cp "${path}" "${newpath}"

"${open_with}" "${newpath}" &
