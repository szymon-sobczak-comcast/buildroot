################################################################################
#
# wpeframework-cdmi-clearkey
#
################################################################################
WPEFRAMEWORK_CDMI_CLEARKEY_VERSION = R4.4.1
WPEFRAMEWORK_CDMI_CLEARKEY_SITE_METHOD = git
WPEFRAMEWORK_CDMI_CLEARKEY_SITE = git@github.com:rdkcentral/OCDM-Clearkey.git
WPEFRAMEWORK_CDMI_CLEARKEY_INSTALL_STAGING = YES
WPEFRAMEWORK_CDMI_CLEARKEY_DEPENDENCIES = wpeframework-clientlibraries libopenssl

$(eval $(cmake-package))
