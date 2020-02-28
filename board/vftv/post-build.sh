#!/bin/bash

set -u
set -e

echo "VFTV Post-build: processing $@"

BOARD_DIR="$(dirname $0)"


if [ -f "${BOARD_DIR}/devinput-remote.json" ];
then
	mkdir -p "${TARGET_DIR}/usr/share/WPEFramework/RemoteControl/"
	cp -pf "${BOARD_DIR}/devinput-remote.json" "${TARGET_DIR}/usr/share/WPEFramework/RemoteControl/"
fi

