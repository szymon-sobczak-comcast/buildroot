################################################################################
#
# wpeframework-cdmi-playready
#
################################################################################

WPEFRAMEWORK_CDMI_PLAYREADY_VERSION = e638a71fd7531d1dcb9450933cb5dbce9b23c4e1
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
