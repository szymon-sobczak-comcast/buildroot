#!/bin/sh

export SOURCE=/media/ml
export DESTINATION=/media/vftv

export LD_LIBRARY_PATH=$SOURCE/lib:/lib
export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:$SOURCE/usr/lib:/usr/lib
export PATH=$SOURCE/usr/bin:$PATH

export GST_PLUGIN_SCANNER=$SOURCE/usr/libexec/gstreamer-1.0/gst-plugin-scanner
export GST_PLUGIN_SYSTEM_PATH=$SOURCE/usr/lib/gstreamer-1.0
export XKB_CONFIG_ROOT=$SOURCE/usr/share/X11/xkb
export XDG_DATA_HOME=/usr/local/metrological/usr/share/
export GIO_MODULE_DIR=/media/ml/usr/lib/gio/modules
# By default nxserver starts with 1080p, launch webkit with same resolution
export WPE_NEXUS_FORMAT="1080p60Hz"

# Currently the root system is read-only. Since we cannot add anything there we bind
# existing directories with a copy of the actual system. All the stuff we want to
# add is symbolicly linked in from our sources..
if [ ! -d $DESTINATION ]; then
    echo "Creating directories..."
    mkdir -p $DESTINATION/etc
    # mkdir -p $DESTINATION/usr/share

    echo "Copying system..."
    cp -rfap /etc/* $DESTINATION/etc/
    # cp -rfap /usr/share/* $DESTINATION/usr/share

    echo "Creating symlinks for directories..."
    rm -rf $DESTINATION/etc/ssl
    ln -fs $SOURCE/etc/ssl $DESTINATION/etc/
    ln -s $SOURCE/etc/ssl/certs/ca-certificates.crt $DESTINATION/etc/ssl/certs/ca-certificates.crt
    rm -rf $DESTINATION/etc/fonts
    ln -fs $SOURCE/etc/fonts $DESTINATION/etc/
    # rm -rf $DESTINATION/usr/share/mime
    # ln -fs $SOURCE/usr/share/mime $DESTINATION/usr/share
    # rm -rf $DESTINATION/usr/share/X11
    # ln -fs $SOURCE/usr/share/X11 $DESTINATION/usr/share
    # rm -rf $DESTINATION/usr/share/WPEFramework
    # ln -fs $SOURCE/usr/share/WPEFramework $DESTINATION/usr/share
    # rm -rf $DESTINATION/usr/share/fonts
    # ln -fs $SOURCE/usr/share/fonts $DESTINATION/usr/share
fi

echo "Mount binding..."
grep -q "/usr/local/metrological/lib" /proc/mounts && echo "/usr/local/metrological/lib is already mounted" || mount -t ext4 --bind $SOURCE/lib/ /usr/local/metrological/lib
grep -q "/usr/local/metrological/usr" /proc/mounts && echo "/usr/local/metrological/usr is already mounted" || mount -t ext4 --bind $SOURCE/usr/ /usr/local/metrological/usr
grep -q "/etc" /proc/mounts && echo "/etc is already mounted" || mount -t ext4 --bind $DESTINATION/etc /etc
# grep -q "/usr/share/" /proc/mounts && echo "/usr/share/" || mount -t ext4 --bind $DESTINATION/usr/share/ /usr/share

echo "Launching $(which WPEFramework)..."
WPEFramework -c $SOURCE/etc/WPEFramework/config.json

echo "Done!"
