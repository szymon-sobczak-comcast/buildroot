################################################################################
#
# libamazon
#
################################################################################

LIBAMAZON_VERSION = 750c0371252d41c5c4e765d0fe4b427f2eee4c20
LIBAMAZON_SITE_METHOD = git
LIBAMAZON_SITE = git@github.com:Metrological/libamazon.git
LIBAMAZON_LICENSE = PROPRIETARY
LIBAMAZON_REDISTRIBUTE = NO
LIBAMAZON_INSTALL_STAGING = YES

LIBAMAZON_DEPENDENCIES = zlib jpeg libcurl libpng wpeframework gstreamer1 gst1-plugins-base gst1-plugins-good gst1-plugins-bad

$(eval $(cmake-package))
