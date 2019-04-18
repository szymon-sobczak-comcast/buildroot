################################################################################
#
# wpeframework-cdmi-clearkey
#
################################################################################

WPEFRAMEWORK_CDMI_CLEARKEY_VERSION = 026c6fb9e809ddfaf2d3487cf0107158d4452b26
WPEFRAMEWORK_CDMI_CLEARKEY_SITE_METHOD = git
WPEFRAMEWORK_CDMI_CLEARKEY_SITE = git@github.com:WebPlatformForEmbedded/OCDM-Clearkey.git
WPEFRAMEWORK_CDMI_CLEARKEY_INSTALL_STAGING = YES
WPEFRAMEWORK_CDMI_CLEARKEY_DEPENDENCIES = wpeframework

$(eval $(cmake-package))
