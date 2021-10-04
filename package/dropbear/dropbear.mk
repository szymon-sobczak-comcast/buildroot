################################################################################
#
# dropbear
#
################################################################################

DROPBEAR_VERSION = 2020.81
DROPBEAR_SITE = https://mirror.dropbear.nl/mirror/releases
DROPBEAR_SOURCE = dropbear-$(DROPBEAR_VERSION).tar.bz2
DROPBEAR_LICENSE = MIT, BSD-2c-like, BSD-2c
DROPBEAR_LICENSE_FILES = LICENSE

DROPBEAR_TARGET_BINS = dropbearkey dropbearconvert scp
DROPBEAR_PROGRAMS = $(DROPBEAR_TARGET_BINS)

# Disable hardening flags added by dropbear configure.ac, and let
# Buildroot add them when the relevant options are enabled. This
# prevents dropbear from using SSP support when not available.
DROPBEAR_CONF_OPTS = --disable-harden

define DROPBEAR_APPLY_LOCAL_PATCHES
 # Apply these patches only incase of WPEFramework/DropbearServer plugin is enabled.
 $(APPLY_PATCHES) $(@D) package/dropbear/ *.patch.conditional
endef

ifeq ($(BR2_PACKAGE_DROPBEAR_CLIENT),y)
# Build dbclient, and create a convenience symlink named ssh
DROPBEAR_PROGRAMS += dbclient
DROPBEAR_TARGET_BINS += dbclient ssh
endif

ifeq ($(BR2_PACKAGE_DROPBEAR_PROGRAM),y)
DROPBEAR_PROGRAMS+=dropbear
DROPBEAR_MAKE = \
        $(MAKE) MULTI=1 SCPPROGRESS=1 \
        PROGRAMS="$(DROPBEAR_PROGRAMS)"
else #case for BR2_PACKAGE_DROPBEAR_LIB
DROPBEAR_POST_PATCH_HOOKS += DROPBEAR_APPLY_LOCAL_PATCHES
DROPBEAR_AUTORECONF = YES
DROPBEAR_MAKE = \
	$(MAKE) DROPBEAR_SHARED_LIB=1 MULTI=1 SCPPROGRESS=1 \
	PROGRAMS="$(DROPBEAR_PROGRAMS)"     
endif

ifeq ($(BR2_STATIC_LIBS),y)
DROPBEAR_MAKE += STATIC=1
endif


define DROPBEAR_INSTALL_INIT_SYSTEMD
	$(INSTALL) -D -m 644 package/dropbear/dropbear.service \
	$(TARGET_DIR)/usr/lib/systemd/system/dropbear.service
	mkdir -p $(TARGET_DIR)/etc/systemd/system/multi-user.target.wants
	ln -fs ../../../../usr/lib/systemd/system/dropbear.service \
	$(TARGET_DIR)/etc/systemd/system/multi-user.target.wants/dropbear.service
endef

ifeq ($(BR2_USE_MMU),y)
define DROPBEAR_INSTALL_INIT_SYSV
	$(INSTALL) -D -m 755 package/dropbear/S50dropbear \
	$(TARGET_DIR)/etc/init.d/S50dropbear
endef
endif


ifneq ($(BR2_PACKAGE_DROPBEAR_WTMP),y)
DROPBEAR_CONF_OPTS += --disable-wtmp
endif

ifneq ($(BR2_PACKAGE_DROPBEAR_LASTLOG),y)
DROPBEAR_CONF_OPTS += --disable-lastlog
endif

ifeq ($(BR2_PACKAGE_DROPBEAR_LIB),y)
define DROPBEAR_INSTALL_TARGET_CMDS
        ln -snf /var/run/dropbear $(TARGET_DIR)/etc/dropbear
        $(INSTALL) -D $(@D)/libdropbear.so $(TARGET_DIR)/usr/lib
	$(INSTALL) -D $(@D)/libdropbear.so $(STAGING_DIR)/usr/lib
        $(INSTALL) -D $(@D)/libdropbear.h $(STAGING_DIR)/usr/include
        $(INSTALL) -D $(@D)/libdropbear.pc $(STAGING_DIR)/usr/lib/pkgconfig/libdropbear.pc
endef
endif

ifeq ($(BR2_PACKAGE_DROPBEAR_PROGRAM),y)
define DROPBEAR_INSTALL_TARGET_CMDS
        $(INSTALL) -m 755 $(@D)/dropbearmulti $(TARGET_DIR)/usr/sbin/dropbear
        for f in $(DROPBEAR_TARGET_BINS); do \
        ln -snf ../sbin/dropbear $(TARGET_DIR)/usr/bin/$$f ; \
        done
        ln -snf /var/run/dropbear $(TARGET_DIR)/etc/dropbear
endef
endif

$(eval $(autotools-package))
