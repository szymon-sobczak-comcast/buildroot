<<<<<<< HEAD
################################################################################
#
# libgphoto2
#
################################################################################

LIBGPHOTO2_VERSION = 2.5.23
LIBGPHOTO2_SOURCE = libgphoto2-$(LIBGPHOTO2_VERSION).tar.bz2
# Project is maintained on github but github tarball doesn't have
# configure, so use tarballs from SourceForge
LIBGPHOTO2_SITE = https://downloads.sourceforge.net/project/gphoto/libgphoto/$(LIBGPHOTO2_VERSION)
LIBGPHOTO2_LICENSE = LGPL-2.1+, GPL-2.0 (adc65), GPL-2.0+ (some camlibs), \
	LGPL-2.0 (sipix), LGPL-3.0+ (pentax), BSD-3-Clause (ax203/tinyjpeg)
# There is a single license file for the LGPL-2.1, no license files
# for other licenses
LIBGPHOTO2_LICENSE_FILES = COPYING
LIBGPHOTO2_INSTALL_STAGING = YES

LIBGPHOTO2_DEPENDENCIES = libxml2 libusb libtool host-pkgconf

LIBGPHOTO2_CONF_ENV = udevscriptdir=/lib/udev
LIBGPHOTO2_CONF_OPTS += --without-rpmbuild --disable-gp2ddb --disable-internal-docs

ifeq ($(BR2_PACKAGE_LIBUSB_COMPAT),y)
# libusb-compat is not actually used, but it is detected, so add it
# here to guarantee reproducible builds
LIBGPHOTO2_DEPENDENCIES += libusb-compat
endif

ifeq ($(BR2_PACKAGE_LIBEXIF),y)
LIBGPHOTO2_DEPENDENCIES += libexif
LIBGPHOTO2_CONF_OPTS += --with-libexif=auto
else
LIBGPHOTO2_CONF_OPTS += --with-libexif=no
endif

ifeq ($(BR2_PACKAGE_JPEG),y)
LIBGPHOTO2_DEPENDENCIES += jpeg
LIBGPHOTO2_CONF_OPTS += --with-jpeg
else
LIBGPHOTO2_CONF_OPTS += --without-jpeg
endif

ifeq ($(BR2_PACKAGE_GD),y)
LIBGPHOTO2_DEPENDENCIES += gd
LIBGPHOTO2_CONF_OPTS += --with-gdlib=auto
else
LIBGPHOTO2_CONF_OPTS += --with-gdlib=no
endif

ifeq ($(BR2_PACKAGE_LOCKDEV),y)
LIBGPHOTO2_DEPENDENCIES += lockdev
endif
=======
#############################################################
#
# libgphoto2
#
#############################################################
LIBGPHOTO2_VERSION= libgphoto2-2_5_11-release
LIBGPHOTO2_SITE_METHOD = git
LIBGPHOTO2_SITE = git@github.com:gphoto/libgphoto2.git
LIBGPHOTO2_INSTALL_STAGING = YES
LIBGPHOTO2_INSTALL_TARGET = YES
LIBGPHOTO2_LICENSE_FILES = COPYING
LIBGPHOTO2_LICENSE = LGPLv2+, LGPLv2.1+
LIBGPHOTO2_DEPENDENCIES = libtool libusb libexif gettext libxml2

LIBGPHOTO2_DEPENDENCIES_PARANOID_UNSAFE_PATH = BR2_COMPILER_PARANOID_UNSAFE_PATH

LIBGPHOTO2_PRE_CONFIGURE_HOOKS += LIBGPHOTO2_RUN_AUTORECONF
LIBGPHOTO2_POST_INSTALL_TARGET_HOOKS += LIBGPHOTO2_REMOVE_LA_FILES 

define LIBGPHOTO2_RUN_AUTORECONF
	cd $(@D) && $(HOST_DIR)/usr/bin/autoreconf --install --symlink
endef

define LIBGPHOTO2_REMOVE_LA_FILES
	rm -f $(TARGET_DIR)/usr/lib/libgphoto2*.la $(TARGET_DIR)/usr/lib/libgphoto2/*/*.la
	rm -f $(TARGET_DIR)/usr/lib/libgphoto2*.a $(TARGET_DIR)/usr/lib/libgphoto2/*/*.a
endef
>>>>>>> origin/master

$(eval $(autotools-package))
