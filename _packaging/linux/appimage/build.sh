#!/bin/bash

export ARCH="x86_64"
export NO_GLIBC_VERSION="1"
export VERSION="$1"

wget https://github.com/AppImage/AppImages/raw/master/pkg2appimage
chmod +x ./pkg2appimage

./pkg2appimage ./JackboxUtility.yml
rm ./pkg2appimage
