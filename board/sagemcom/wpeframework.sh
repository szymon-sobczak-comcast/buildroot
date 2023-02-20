#!/bin/sh

export SOURCE=/mnt
export LD_LIBRARY_PATH=$SOURCE/usr/lib:$SOURCE/lib:/lib:/usr/lib:$SOURCE/usr/lib/wpeframework/plugins:$SOURCE/usr/lib/wpeframework/proxystubs:$SOURCE/usr/lib/wpe-webkit-1.0
export PATH=$SOURCE/usr/bin:$PATH
export SAGEBIN_PATH=/usr/bin/
export PAK_PATH=/usr/bin/
export DRM_PATH=/usr/bin/

#export WESTEROS_SINK_USE_ESSRMGR=1
#export XKB_CONFIG_ROOT=$SOURCE/usr/share/X11/xkb
#export GST_DEBUG=webkit*:7,brcm*:7,westeros*:7
#export GST_DEBUG_DUMP_DOT_DIR=/mnt/

#export RDKSHELL_STARTUP_CONFIG=/etc/rdkshell_post_startup.conf
#export WESTEROS_SINK_USE_ESSRMGR=1
#export GST_ENABLE_SVP=y
#export RDKSHELL_FRAMERATE=60
export WPE_WEBSRC_MAX_BYTES=4194304

if [ ! -d /usr/libexec/wpe-webkit-1.0 ]; then
	ln -s $SOURCE/usr/libexec/wpe-webkit-1.0 /usr/libexec/wpe-webkit-1.0
fi
if [ ! -d /usr/lib/wpe-webkit-1.0 ]; then
	ln -s $SOURCE/usr/lib/wpe-webkit-1.0 /usr/lib/wpe-webkit-1.0
fi
$SOURCE/usr/bin/WPEFramework -c $SOURCE/etc/WPEFramework/config.json &

