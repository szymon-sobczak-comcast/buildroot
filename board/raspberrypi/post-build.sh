#!/bin/bash

set -u
set -e

echo "Post-build: processing $@"

BOARD_DIR="$(dirname $0)"

# Add Gstreamer software based AC3 Decoder
if [ -f "${BOARD_DIR}/libgstfluac3dec.so" ]; then
	mkdir -p "${TARGET_DIR}/usr/lib/gstreamer-1.0/"
	cp -pf "${BOARD_DIR}/libgstfluac3dec.so" "${TARGET_DIR}/usr/lib/gstreamer-1.0/"
fi

# Copy config.json to webserver
if [ -f "${BOARD_DIR}/config.json" ]; then
	mkdir -p "${TARGET_DIR}/www/"
	cp -pf "${BOARD_DIR}/config.json" "${TARGET_DIR}/www/"
fi

# Copy keymap for OSMC remote
if [ -f "${BOARD_DIR}/osmc-devinput-remote.json" ]; then
	mkdir -p "${TARGET_DIR}/usr/share/WPEFramework/RemoteControl/"
	cp -pf "${BOARD_DIR}/osmc-devinput-remote.json" "${TARGET_DIR}/usr/share/WPEFramework/RemoteControl/devinput-remote.json"
fi

if grep -q "^BR2_TARGET_ROOTFS_INITRAMFS=y$" "${BR2_CONFIG}"; then

mkdir -p "${TARGET_DIR}/boot"
grep -q '^/dev/mmcblk0p1' "${TARGET_DIR}/etc/fstab" || \
    echo '/dev/mmcblk0p1 /boot vfat defaults 0 0' >> "${TARGET_DIR}/etc/fstab"

mkdir -p "${TARGET_DIR}/root"
grep -q '^/dev/mmcblk0p2' "${TARGET_DIR}/etc/fstab" || \
    echo '/dev/mmcblk0p2 /root ext4 defaults 0 0' >> "${TARGET_DIR}/etc/fstab"

fi
