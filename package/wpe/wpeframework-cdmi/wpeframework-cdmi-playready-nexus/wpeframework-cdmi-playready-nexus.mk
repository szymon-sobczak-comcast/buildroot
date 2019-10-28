################################################################################
#
# wpeframework-cdmi-playready-nexus
#
################################################################################

WPEFRAMEWORK_CDMI_PLAYREADY_NEXUS_VERSION = 1ac9cb38a9518c032cce34b04de40b8e7e2f06e6
WPEFRAMEWORK_CDMI_PLAYREADY_NEXUS_SITE_METHOD = git
WPEFRAMEWORK_CDMI_PLAYREADY_NEXUS_SITE = git@github.com:WebPlatformForEmbedded/OCDM-Playready-Nexus.git
WPEFRAMEWORK_CDMI_PLAYREADY_NEXUS_INSTALL_STAGING = YES
WPEFRAMEWORK_CDMI_PLAYREADY_NEXUS_DEPENDENCIES = wpeframework

ifneq ($(BR2_PACKAGE_BCM_REFSW),)
WPEFRAMEWORK_CDMI_PLAYREADY_NEXUS_DEPENDENCIES += bcm-refsw
endif

$(eval $(cmake-package))
