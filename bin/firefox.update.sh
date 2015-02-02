#!/usr/bin/env sh
update_dir='/tmp/firefox_update'
install_dir='/opt/firefox-nightly'
apply_to_dir='/opt/firefox-nightly'

rm -rf "${update_dir}"
mkdir -p "${update_dir}"

rooturl='http://ftp.mozilla.org/pub/mozilla.org/firefox/nightly/latest-trunk/'
filename=$(curl $rooturl 2>/dev/null \
    | grep 'linux-x86_64.complete.mar"' \
    | sed -re 's/.*<a href="([^"]+)">.*/\1/' \
    | tail -1)
url="${rooturl}${filename}"

echo "Downloading mar file for ${url} ..."
curl "${url}" -o "${update_dir}/update.mar"
cp "${install_dir}/updater" "${install_dir}/updater.ini" "${update_dir}"

echo "Running update..."
cd "${install_dir}" \
    && sudo "${update_dir}/updater" "${update_dir}" "${install_dir}" "${apply_to_dir}" \
    && cd $OLDPWD

cat "${update_dir}/update.status"
