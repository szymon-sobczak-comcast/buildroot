################################################################################
#
# wpeframework-cdmi-playready-nexus-svp
#
################################################################################

WPEFRAMEWORK_CDMI_PLAYREADY_NEXUS_SVP_VERSION = 22c33f1776df675bc25b43c4f674bd18bc2ecd83
WPEFRAMEWORK_CDMI_PLAYREADY_NEXUS_SVP_SITE_METHOD = git
WPEFRAMEWORK_CDMI_PLAYREADY_NEXUS_SVP_SITE = git@github.com:WebPlatformForEmbedded/OCDM-Playready-Nexus-SVP.git
WPEFRAMEWORK_CDMI_PLAYREADY_NEXUS_SVP_INSTALL_STAGING = YES
WPEFRAMEWORK_CDMI_PLAYREADY_NEXUS_SVP_DEPENDENCIES = wpeframework-clientlibraries

ifeq ($(BR2_PACKAGE_BCM_REFSW),y)
WPEFRAMEWORK_CDMI_PLAYREADY_NEXUS_SVP_DEPENDENCIES += bcm-refsw
endif

ifeq ($(BR2_PACKAGE_WPEFRAMEWORK_CDMI_PLAYREADY_NEXUS_SVP_ENABLE),y)
WPEFRAMEWORK_CDMI_PLAYREADY_NEXUS_SVP_CONF_OPTS += -DNEXUS_PLAYREADY_SVP_ENABLE=ON
endif

$(eval $(cmake-package))
