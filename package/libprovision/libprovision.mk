################################################################################
#
# libprovision
#
################################################################################

LIBPROVISION_VERSION = 140cc895909d760a053cf6ba1b1cac51360d11d5
LIBPROVISION_SITE_METHOD = git
LIBPROVISION_SITE = git@github.com:Metrological/libprovision.git
LIBPROVISION_LICENSE = PROPRIETARY
LIBPROVISION_REDISTRIBUTE = NO
LIBPROVISION_INSTALL_STAGING = YES

LIBPROVISION_DEPENDENCIES = libopenssl

$(eval $(cmake-package))
