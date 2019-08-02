################################################################################
#
# wpeframework-cdmi-playready-nexus
#
################################################################################

WPEFRAMEWORK_CDMI_PLAYREADY_NEXUS_VERSION = 7c3a2fe8a458e0472405b50ada2cd66433042e52
WPEFRAMEWORK_CDMI_PLAYREADY_NEXUS_SITE_METHOD = git
WPEFRAMEWORK_CDMI_PLAYREADY_NEXUS_SITE = git@github.com:WebPlatformForEmbedded/OCDM-Playready-Nexus.git
WPEFRAMEWORK_CDMI_PLAYREADY_NEXUS_INSTALL_STAGING = YES
WPEFRAMEWORK_CDMI_PLAYREADY_NEXUS_DEPENDENCIES = wpeframework

ifneq ($(BR2_PACKAGE_BCM_REFSW),)
WPEFRAMEWORK_CDMI_PLAYREADY_NEXUS_DEPENDENCIES += bcm-refsw
endif

$(eval $(cmake-package))
