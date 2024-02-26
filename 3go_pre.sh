#!/bin/bash
TARGET_FOLDER="device/generic/common/nativebridge/system/lib/arm/"

if [ -z "$(ls -A $TARGET_FOLDER)" ]; then
	wget http://dl.android-x86.org/houdini/9_y/houdini.sfs -O docker/houdini.sfs
	mkdir -p $TARGET_FOLDER
	unsquashfs -f -d $TARGET_FOLDER docker/houdini.sfs
else
	echo "================= SKIP houdini"
fi


sudo apt-get install git-core gnupg flex bison build-essential zip curl zlib1g-dev libc6-dev-i386 libncurses5 lib32ncurses5-dev x11proto-core-dev libx11-dev lib32z1-dev libgl1-mesa-dev libxml2-utils xsltproc unzip fontconfig git git-lfs
