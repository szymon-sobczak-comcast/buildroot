#!/bin/bash

set -u
set -e

echo "MultiChoice Post-build: processing $@"

BOARD_DIR="$(dirname $0)"

# Copy index.html page for WPE Framework
if [ -f "${BOARD_DIR}/index.html" ]; then
	mkdir -p "${TARGET_DIR}/www/"
	cp -pf "${BOARD_DIR}/index.html" "${TARGET_DIR}/www/"
fi

# Create links for PlayReady
mkdir -p "${TARGET_DIR}/etc/playready/"
mkdir -p "${TARGET_DIR}/root/OCDM/"
ln -sf /tmp/drmstore "${TARGET_DIR}/etc/playready/storage"
ln -sf /etc/playready "${TARGET_DIR}/root/OCDM/playready"
