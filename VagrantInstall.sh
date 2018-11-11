#!/bin/sh

function installdmg {
    set -x
    tempd=$(mktemp -d)
    curl $1 > $tempd/pkg.dmg
    listing=$(sudo hdiutil attach $tempd/pkg.dmg | grep Volumes)
    volume=$(echo "$listing" | cut -f 3)
    if [ -e "$volume"/*.app ]; then
      sudo cp -rf "$volume"/*.app /Applications
    elif [ -e "$volume"/*.pkg ]; then
      package=$(ls $volume | grep pkg | head -1)
      sudo installer -pkg "$volume"/"$package" -target /
    fi
    sudo hdiutil detach $volume
    rm -rf $tempd
    set +x
}


echo "Getting download link"
DOWNLOAD_LINK=$(curl https://www.vagrantup.com/downloads.html | grep '_64.dmg' | awk -F'"' '{print $8}') 
echo "Installing DMG"
installdmg $DOWNLOAD_LINK
