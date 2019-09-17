################################################################################
#
# libamazon
#
################################################################################

LIBAMAZON_VERSION = ab22d1a5262223b562fc72d4c6f645712c8f87d2
LIBAMAZON_SITE_METHOD = git
LIBAMAZON_SITE = git@github.com:Metrological/libamazon.git
LIBAMAZON_LICENSE = PROPRIETARY
LIBAMAZON_REDISTRIBUTE = NO
LIBAMAZON_INSTALL_STAGING = YES

LIBAMAZON_DEPENDENCIES = zlib jpeg libcurl libpng wpeframework gstreamer1 gst1-plugins-base gst1-plugins-good gst1-plugins-bad

$(eval $(cmake-package))
