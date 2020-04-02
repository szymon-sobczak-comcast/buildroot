#!/bin/sh

export SOURCE=/Systemapps/wpe/metrological/
export LD_LIBRARY_PATH=$SOURCE/usr/lib:/lib:/usr/lib:$SOURCE/lib:$SOURCE/usr/lib/wpeframework/plugins:$SOURCE/usr/lib/wpeframework/proxystubs:$SOURCE/usr/lib/gio
export PATH=$SOURCE/usr/bin:$PATH:/usr/bin
export GST_PLUGIN_SCANNER=$SOURCE/usr/libexec/gstreamer-1.0/gst-plugin-scanner
export GST_PLUGIN_SYSTEM_PATH=$SOURCE/usr/lib/gstreamer-1.0

export XKB_CONFIG_ROOT=$SOURCE/usr/share/X11/xkb
export V3D_DRM_DISABLE=1

case "$1" in
*)
	export DESTINATION=/UserApps/explora
	
	playready_bin="/tmp/playready3x.bin"
	if [ ! -f "${playready_bin}" ]; then
		echo "ERROR: Playready ${playready_bin} not found!"
	else
		cp -rf "${playready_bin}" /usr/bin/bcm-drm-examples/pr
	fi
	# Currently the root system is read-only. Since we cannot add anything there we bind 
	# existing directories with a copy of the actual system. All the stuff we want to 
	# add is symbolicly linked in from our sources..
	if [ ! -d $DESTINATION ]; then

		mkdir -p $DESTINATION/share
		mkdir -p $DESTINATION/etc
		mkdir -p $DESTINATION/root
		cp -rfap /usr/share/* $DESTINATION/share
		cp -rfap /etc/* $DESTINATION/etc
		cp -rfap /root/* $DESTINATION/root

		ln -s $SOURCE/usr/share/mime $DESTINATION/share/mime
		ln -s $SOURCE/usr/share/X11 $DESTINATION/share/X11
		ln -s $SOURCE/usr/share/WPEFramework $DESTINATION/share/WPEFramework
		ln -s $SOURCE/usr/share/content $DESTINATION/share/content
		ln -s $SOURCE/usr/share/fonts $DESTINATION/share/fonts
		ln -s $SOURCE/etc/ssl $DESTINATION/etc/ssl
		ln -s $SOURCE/etc/ssl $DESTINATION/lib/ssl
		ln -s $SOURCE/etc/fonts $DESTINATION/etc/fonts
		ln -s $SOURCE/etc/WPEFramework $DESTINATION/etc/WPEFramework
		ln -s $SOURCE/etc/WideVine $DESTINATION/etc/WideVine
		ln -s $SOURCE/etc/playready $DESTINATION/etc/playready
		ln -s $SOURCE/root/Netflix $DESTINATION/root/Netflix
		ln -s $SOURCE/root/OCDM $DESTINATION/root/OCDM
                ln -s /usr/bin/sage/sage_ta_widevine.bin $SOURCE/sage_ta_widevine.bin
	fi

	cp -fa $SOURCE/usr/bin/. /usr/bin

	export DRMSTORE=/tmp/drmstore
	if [ ! -f $DRMSTORE ]; then
		touch /tmp/drmstore
	fi

	grep -q "/usr/share ext4" /proc/mounts && echo "/usr/share is already mounted" || mount -t ext4 --bind $DESTINATION/share/ /usr/share/
	grep -q "/etc ext4" /proc/mounts && echo "/etc is already mounted" || mount -t ext4 --bind $DESTINATION/etc/ /etc/
	grep -q "/root ext4" /proc/mounts && echo "/root is already mounted" || mount -t ext4 --bind $DESTINATION/root/ /root/

	WPEFramework -c $SOURCE/etc/WPEFramework/config.json
;;
esac

