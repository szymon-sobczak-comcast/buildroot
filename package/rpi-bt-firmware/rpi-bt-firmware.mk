################################################################################
#
# rpi-bt-firmware
#
################################################################################

<<<<<<< HEAD
RPI_BT_FIRMWARE_VERSION = 688531da4bcf802a814d9cb0c8b6d62e3b8a3327
RPI_BT_FIRMWARE_SITE = $(call github,LibreELEC,brcmfmac_sdio-firmware-rpi,$(RPI_BT_FIRMWARE_VERSION))
RPI_BT_FIRMWARE_LICENSE = PROPRIETARY
RPI_BT_FIRMWARE_LICENSE_FILES = LICENCE.broadcom_bcm43xx

define RPI_BT_FIRMWARE_INSTALL_TARGET_CMDS
	$(INSTALL) -d $(TARGET_DIR)/lib/firmware/brcm
	$(INSTALL) -m 0644 $(@D)/firmware/brcm/*.hcd $(TARGET_DIR)/lib/firmware/brcm
endef
=======

RPI_BT_CHIP = ""

ifdef BR2_PACKAGE_RPI_VERSION_RPI0
RPI_BT_CHIP = "BCM43430A1"
endif

ifdef BR2_PACKAGE_RPI_VERSION_RPI3
RPI_BT_CHIP = "BCM43430A1"
endif

ifdef BR2_PACKAGE_RPI_VERSION_RPI3PLUS
RPI_BT_CHIP = "BCM4345C0"
endif

ifeq ($(RPI_BT_CHIP),"BCM43430A1")
RPI_BT_FIRMWARE_VERSION = 9edf5584d3ee4ffcd6200dd84252545622539462
RPI_BT_FIRMWARE_SITE = https://aur.archlinux.org/pi-bluetooth.git
RPI_BT_FIRMWARE_SITE_METHOD = git
RPI_BT_FIRMWARE_LICENSE = PROPRIETARY
RPI_BT_FIRMWARE_LICENSE_FILES = LICENCE.broadcom_bcm43xx

# The BlueZ hciattach utility looks for firmware in /etc/firmware. Add a
# compatibility symlink.
define RPI_BT_FIRMWARE_INSTALL_TARGET_CMDS
	ln -sf ../lib/firmware $(TARGET_DIR)/etc/firmware
	$(INSTALL) -D -m 0644 $(@D)/BCM43430A1.hcd \
		$(TARGET_DIR)/lib/firmware/BCM43430A1.hcd
endef

else ifeq ($(RPI_BT_CHIP),"BCM4345C0")
RPI_BT_FIRMWARE_VERSION = fff76cb15527c435ce99a9787848eacd6288282c
RPI_BT_FIRMWARE_SITE = https://github.com/RPi-Distro/bluez-firmware.git
RPI_BT_FIRMWARE_SITE_METHOD = git
RPI_BT_FIRMWARE_LICENSE = PROPRIETARY

# The BlueZ hciattach utility looks for firmware in /etc/firmware. Add a
# compatibility symlink.
define RPI_BT_FIRMWARE_INSTALL_TARGET_CMDS
	ln -sf ../lib/firmware $(TARGET_DIR)/etc/firmware
	$(INSTALL) -D -m 0644 $(@D)/broadcom/BCM4345C0.hcd \
		$(TARGET_DIR)/lib/firmware/BCM4345C0.hcd
endef
endif
>>>>>>> origin/master

$(eval $(generic-package))
