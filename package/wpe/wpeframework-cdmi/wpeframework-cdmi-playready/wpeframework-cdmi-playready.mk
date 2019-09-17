################################################################################
#
# wpeframework-cdmi-playready
#
################################################################################

WPEFRAMEWORK_CDMI_PLAYREADY_VERSION = 32e59dbe19a9760a7a3d70f6c2071af86d0a0f9d
WPEFRAMEWORK_CDMI_PLAYREADY_SITE_METHOD = git
WPEFRAMEWORK_CDMI_PLAYREADY_SITE = git@github.com:WebPlatformForEmbedded/OCDM-Playready.git
WPEFRAMEWORK_CDMI_PLAYREADY_INSTALL_STAGING = YES
WPEFRAMEWORK_CDMI_PLAYREADY_DEPENDENCIES = wpeframework playready

define WPEFRAMEWORK_CDMI_PLAYREADY_PREPARE_DIRS
	mkdir -p $(TARGET_DIR)$(BR2_PACKAGE_WPEFRAMEWORK_PERSISTENT_PATH)/OCDM/playready/state
	ln -sf /etc/playready/ $(TARGET_DIR)$(BR2_PACKAGE_WPEFRAMEWORK_PERSISTENT_PATH)/OCDM/playready/playready
endef

WPEFRAMEWORK_CDMI_PLAYREADY_POST_INSTALL_TARGET_HOOKS += WPEFRAMEWORK_CDMI_PLAYREADY_PREPARE_DIRS

$(eval $(cmake-package))
