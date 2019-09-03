################################################################################
#
# wpeframework-cdmi-playready-vgdrm 
#
################################################################################

WPEFRAMEWORK_CDMI_PLAYREADY_VGDRM_VERSION = cb7052e1834c71f71caec95ad75723b2a2232bed
WPEFRAMEWORK_CDMI_PLAYREADY_VGDRM_SITE_METHOD = git
WPEFRAMEWORK_CDMI_PLAYREADY_VGDRM_SITE = git@github.com:WebPlatformForEmbedded/OCDM-Playready-VGDRM.git
WPEFRAMEWORK_CDMI_PLAYREADY_VGDRM_INSTALL_STAGING = YES
WPEFRAMEWORK_CDMI_PLAYREADY_VGDRM_DEPENDENCIES = wpeframework vss-sdk

$(eval $(cmake-package))
