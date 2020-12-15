################################################################################
#
# opkg
#
################################################################################

OPKG_VERSION = 0.4.2
OPKG_SITE = http://downloads.yoctoproject.org/releases/opkg
OPKG_DEPENDENCIES = host-pkgconf libarchive
OPKG_LICENSE = GPL-2.0+
OPKG_LICENSE_FILES = COPYING
OPKG_INSTALL_STAGING = YES
<<<<<<< HEAD
OPKG_CONF_OPTS = --disable-curl
=======
OPKG_CONF_OPTS = --enable-libopkg-api
OPKG_AUTORECONF = YES
>>>>>>> origin/master

# Ensure directory for lockfile exists
define OPKG_CREATE_LOCKDIR
	mkdir -p $(TARGET_DIR)/usr/lib/opkg
endef

ifeq ($(BR2_PACKAGE_OPKG_GPG_SIGN),y)
OPKG_CONF_OPTS += --enable-gpg
OPKG_CONF_ENV += \
	ac_cv_path_GPGME_CONFIG=$(STAGING_DIR)/usr/bin/gpgme-config \
	ac_cv_path_GPGERR_CONFIG=$(STAGING_DIR)/usr/bin/gpg-error-config
OPKG_DEPENDENCIES += libgpgme libgpg-error
else
OPKG_CONF_OPTS += --disable-gpg
endif

ifeq ($(BR2_PACKAGE_OPKG_USE_CURL), y)
OPKG_DEPENDENCIES += libcurl
else
OPKG_CONF_OPTS += --disable-curl
endif

ifeq ($(BR2_PACKAGE_WPEFRAMEWORK_PROVISIONPROXY),y)
OPKG_CONF_OPTS += --enable-provision
OPKG_DEPENDENCIES += wpeframework
endif

OPKG_POST_INSTALL_TARGET_HOOKS += OPKG_CREATE_LOCKDIR

$(eval $(autotools-package))
