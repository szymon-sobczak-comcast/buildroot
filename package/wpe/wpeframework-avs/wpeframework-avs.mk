################################################################################
#
# wpeframework-avs
#
################################################################################

# TODO set version, for now use the OVERRIDE
WPEFRAMEWORK_AVS_VERSION = abcde
WPEFRAMEWORK_AVS_SITE_METHOD = git
WPEFRAMEWORK_AVS_SITE = git@github.com:WebPlatformForEmbedded/WPEPluginAVS.git
WPEFRAMEWORK_AVS_INSTALL_STAGING = YES
WPEFRAMEWORK_AVS_CONF_OPTS += -DBUILD_REFERENCE=${WPEFRAMEWORK_AVS_VERSION}
WPEFRAMEOWRK_AVS_DEPENDECIES += avs-device-sdk

WPEFRAMEOWORK_AVS_PORT_INSTALL_HOOKS += CREATE_DIR_STRUCTURE
define CREATE_DIR_STRUCTURE
	$(INSTALL) -d $(TARGET_DIR)/etc/avs
	$(INSTALL) -d $(TARGET_DIR)/etc/avs/db
endef

$(eval $(cmake-package))
