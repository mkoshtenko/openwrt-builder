#!/bin/sh

# TODO: pass image name as an argument.
IMAGE_NAME="openwrt-rpi-4.img.gz"
IMAGE_DIR="/home/vagrant/builds"
IMAGE_PATH="$IMAGE_DIR/$IMAGE_NAME"

if [ -f "$IMAGE_PATH" ]; then
    echo "[OK] Image $IMAGE_NAME exists."
else
    echo "[FAIL] Image $IMAGE_NAME does not exist"
    exit 0
fi

echo '[OK]'
exit 0

