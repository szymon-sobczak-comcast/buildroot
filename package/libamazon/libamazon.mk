################################################################################
#
# libamazon
#
################################################################################

LIBAMAZON_VERSION = dca2d056f0e45711fe7c4555bb117cc8f338b15f
LIBAMAZON_SITE_METHOD = git
LIBAMAZON_SITE = git@github.com:Metrological/libamazon.git
LIBAMAZON_LICENSE = PROPRIETARY
LIBAMAZON_REDISTRIBUTE = NO
LIBAMAZON_INSTALL_STAGING = YES

LIBAMAZON_DEPENDENCIES = zlib jpeg libcurl libpng wpeframework gstreamer1 gst1-plugins-base gst1-plugins-good gst1-plugins-bad

$(eval $(cmake-package))
