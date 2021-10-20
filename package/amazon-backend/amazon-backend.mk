################################################################################
#
# amazon-backend
#
################################################################################

# use vss-svp branch
AMAZON_BACKEND_VERSION = 2e54f1c65a0958bb10114eb15488dd907fa339fa
AMAZON_BACKEND_SITE = git@github.com:Metrological/amazon-backend.git
AMAZON_BACKEND_SITE_METHOD = git
AMAZON_BACKEND_DEPENDENCIES =
AMAZON_BACKEND_LICENSE = PROPRIETARY
AMAZON_BACKEND_INSTALL_STAGING = YES

AMAZON_BACKEND_DEPENDENCIES += wpeframework

ifeq ($(BR2_PACKAGE_GSTREAMER1),y)
AMAZON_BACKEND_DEPENDENCIES += gstreamer1 gst1-plugins-base gst1-plugins-good gst1-plugins-bad
endif

ifeq ($(BR2_PACKAGE_BCM_REFSW),y)
AMAZON_BACKEND_DEPENDENCIES += bcm-refsw
endif

ifeq  ($(BR2_PACKAGE_AMAZON_BUILD_TYPE_TESTING),y)
AMAZON_BACKEND_CONF_OPTS += -DAMAZON_BUILD_TYPE="testing"
endif

ifeq  ($(BR2_PACKAGE_VSS_SDK),y)
AMAZON_BACKEND_CONF_OPTS += -DAMAZON_GST_LIBRARY_PREFIX="wpe"
endif

$(eval $(cmake-package))
