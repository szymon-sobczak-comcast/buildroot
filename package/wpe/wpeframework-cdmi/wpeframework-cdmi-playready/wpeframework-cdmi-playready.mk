################################################################################
#
# wpeframework-cdmi-playready
#
################################################################################

WPEFRAMEWORK_CDMI_PLAYREADY_VERSION = a2badbc432a89853b8a5aaac3dc583fdc796d14d
WPEFRAMEWORK_CDMI_PLAYREADY_SITE_METHOD = git
WPEFRAMEWORK_CDMI_PLAYREADY_SITE = git@github.com:WebPlatformForEmbedded/OCDM-Playready.git
WPEFRAMEWORK_CDMI_PLAYREADY_INSTALL_STAGING = YES
WPEFRAMEWORK_CDMI_PLAYREADY_DEPENDENCIES = wpeframework playready

$(eval $(cmake-package))
