################################################################################
#
# libprovision
#
################################################################################

<<<<<<< HEAD
LIBPROVISION_VERSION = 7e12a81534f797ca62b7590c0572a5ed75e459fb
=======
LIBPROVISION_VERSION = 48cb163f58c3748ed85e541a833283a1f2c9ab05
>>>>>>> origin/master
LIBPROVISION_SITE_METHOD = git
LIBPROVISION_SITE = git@github.com:Metrological/libprovision.git
LIBPROVISION_LICENSE = PROPRIETARY
LIBPROVISION_REDISTRIBUTE = NO
LIBPROVISION_INSTALL_STAGING = YES

LIBPROVISION_DEPENDENCIES = openssl

$(eval $(cmake-package))
