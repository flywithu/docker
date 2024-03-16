#!/bin/bash

TARGET_URL="https://developer.polestar.com/sdk/polestar_emulator_v29.zip"
TARGET_DIR=$(mktemp -d)
TARGET_FILENAME="emu.zip"
if command -v curl &> /dev/null; then
    curl -fLo "$TARGET_DIR/$TARGET_FILENAME" "$TARGET_URL"
elif command -v wget &> /dev/null; then
    wget -O "$TARGET_DIR/$TARGET_FILENAME" "$TARGET_URL"
else
    echo "ERROR!"
    exit 1
fi

pushd $TARGET_DIR
unzip $TARGET_FILENAME
7z x x86_64/system.img -o$TARGET_DIR/extracted
binwalk -e --depth 1 --count 1 -y 'filesystem' extracted/super.img
popd
mkdir -p vendor/opengapps/sources/x86_64/priv-app/com.android.vending.car/29/nodpi
cp -Rf docker/PhoneskyCar vendor/opengapps/build/modules
mkdir -p vendor/opengapps/sources/x86_64/priv-app/com.android.vending.car/29/nodpi
find $TARGET_DIR -name "PhoneskyCarPrebuilt.apk" -exec cp {} vendor/opengapps/sources/x86_64/priv-app/com.android.vending.car/29/nodpi/ \;
