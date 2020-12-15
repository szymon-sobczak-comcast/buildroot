################################################################################
#
# rpi-userland
#
################################################################################

<<<<<<< HEAD
RPI_USERLAND_VERSION = 06bc6daa02137ca72b7a2104afad81e82a44de17
=======
RPI_USERLAND_VERSION = cdb5da59f939eb4078e90ed0e3c231c498ba9957
>>>>>>> origin/master
RPI_USERLAND_SITE = $(call github,raspberrypi,userland,$(RPI_USERLAND_VERSION))
RPI_USERLAND_LICENSE = BSD-3-Clause
RPI_USERLAND_LICENSE_FILES = LICENCE
RPI_USERLAND_INSTALL_STAGING = YES
RPI_USERLAND_CONF_OPTS = -DVMCS_INSTALL_PREFIX=/usr

RPI_USERLAND_PROVIDES = libegl libgles libopenmax libopenvg

<<<<<<< HEAD
=======
ifeq ($(BR2_aarch64),y)
RPI_USERLAND_CONF_OPTS += -DARM64=ON
endif

ifeq ($(BR2_PACKAGE_WAYLAND),y)
RPI_USERLAND_DEPENDENCIES += wayland
RPI_USERLAND_CONF_OPTS += -DBUILD_WAYLAND=1
endif

ifeq ($(BR2_PACKAGE_RPI_USERLAND_START_VCFILED),y)
define RPI_USERLAND_INSTALL_INIT_SYSV
	$(INSTALL) -m 0755 -D package/rpi-userland/S94vcfiled \
		$(TARGET_DIR)/etc/init.d/S94vcfiled
endef
define RPI_USERLAND_INSTALL_INIT_SYSTEMD
	$(INSTALL) -D -m 644 package/rpi-userland/vcfiled.service \
		$(TARGET_DIR)/usr/lib/systemd/system/vcfiled.service
	mkdir -p $(TARGET_DIR)/etc/systemd/system/multi-user.target.wants
	ln -sf ../../../../usr/lib/systemd/system/vcfiled.service \
		$(TARGET_DIR)/etc/systemd/system/multi-user.target.wants/vcfiled.service
endef
endif

>>>>>>> origin/master
ifeq ($(BR2_PACKAGE_RPI_USERLAND_HELLO),y)

RPI_USERLAND_CONF_OPTS += -DALL_APPS=ON

define RPI_USERLAND_EXTRA_LIBS_TARGET
	$(INSTALL) -m 0644 -D \
		$(@D)/build/lib/libilclient.so \
		$(TARGET_DIR)/usr/lib/libilclient.so
endef
RPI_USERLAND_POST_INSTALL_TARGET_HOOKS += RPI_USERLAND_EXTRA_LIBS_TARGET

define RPI_USERLAND_EXTRA_LIBS_STAGING
	$(INSTALL) -m 0644 -D \
		$(@D)/build/lib/libilclient.so \
		$(STAGING_DIR)/usr/lib/libilclient.so
endef
RPI_USERLAND_POST_INSTALL_STAGING_HOOKS += RPI_USERLAND_EXTRA_LIBS_STAGING

else

RPI_USERLAND_CONF_OPTS += -DALL_APPS=OFF

endif # BR2_PACKAGE_RPI_USERLAND_HELLO

define RPI_USERLAND_POST_TARGET_CLEANUP
	rm -Rf $(TARGET_DIR)/usr/src
	ln -sfn libGLESv2.so $(TARGET_DIR)/usr/lib/libGLESv1_CM.so.1.0.0
	ln -sfn libGLESv1_CM.so.1.0.0 $(TARGET_DIR)/usr/lib/libGLESv1_CM.so.1
	ln -sfn libGLESv1_CM.so.1 $(TARGET_DIR)/usr/lib/libGLESv1_CM.so
endef

define RPI_USERLAND_POST_TARGET_LINKS
	ln -sf libEGL.so $(TARGET_DIR)/usr/lib/libEGL.so.1
	ln -sf libGLESv2.so $(TARGET_DIR)/usr/lib/libGLESv2.so.2
endef

RPI_USERLAND_POST_INSTALL_TARGET_HOOKS += RPI_USERLAND_POST_TARGET_CLEANUP
RPI_USERLAND_POST_INSTALL_TARGET_HOOKS += RPI_USERLAND_POST_TARGET_LINKS

$(eval $(cmake-package))
