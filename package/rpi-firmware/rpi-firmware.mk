################################################################################
#
# rpi-firmware
#
################################################################################
<<<<<<< HEAD

RPI_FIRMWARE_VERSION = 01ecfd2ba2b7cf3a2f4aa75ada895ee4a3e729f5
=======
RPI_FIRMWARE_VERSION = e10b2880e26708afc0b32a485c1231207037fc45
>>>>>>> origin/master
RPI_FIRMWARE_SITE = $(call github,raspberrypi,firmware,$(RPI_FIRMWARE_VERSION))
RPI_FIRMWARE_LICENSE = BSD-3-Clause
RPI_FIRMWARE_LICENSE_FILES = boot/LICENCE.broadcom
RPI_FIRMWARE_INSTALL_IMAGES = YES

ifeq ($(BR2_PACKAGE_RPI_FIRMWARE_INSTALL_DTBS),y)
define RPI_FIRMWARE_INSTALL_DTB
	$(foreach dtb,$(wildcard $(@D)/boot/*.dtb), \
		$(INSTALL) -D -m 0644 $(dtb) $(BINARIES_DIR)/rpi-firmware/$(notdir $(dtb))
	)
endef
endif

ifeq ($(BR2_PACKAGE_RPI_FIRMWARE_INSTALL_DTB_OVERLAYS),y)
define RPI_FIRMWARE_INSTALL_DTB_OVERLAYS
	for ovldtb in  $(@D)/boot/overlays/*.dtbo; do \
		$(INSTALL) -D -m 0644 $${ovldtb} $(BINARIES_DIR)/rpi-firmware/overlays/$${ovldtb##*/} || exit 1; \
	done
endef
else
# Still create the directory, so a genimage.cfg can include it independently of
# whether _INSTALL_DTB_OVERLAYS is selected or not.
define RPI_FIRMWARE_INSTALL_DTB_OVERLAYS
	$(INSTALL) -d $(BINARIES_DIR)/rpi-firmware/overlays
endef
endif

ifeq ($(BR2_PACKAGE_RPI_FIRMWARE_INSTALL_VCDBG),y)
define RPI_FIRMWARE_INSTALL_TARGET_CMDS
	$(INSTALL) -D -m 0700 $(@D)/$(if BR2_ARM_EABIHF,hardfp/)opt/vc/bin/vcdbg \
		$(TARGET_DIR)/usr/sbin/vcdbg
	$(INSTALL) -D -m 0644 $(@D)/$(if BR2_ARM_EABIHF,hardfp/)opt/vc/lib/libelftoolchain.so \
		$(TARGET_DIR)/usr/lib/libelftoolchain.so
endef
endif # INSTALL_VCDBG

<<<<<<< HEAD
ifeq ($(BR2_PACKAGE_RPI_FIRMWARE_VARIANT_PI4),y)
=======
ifeq ($(BR2_TOOLCHAIN_HEADERS_AT_LEAST_4_14),y)
define RPI_FIRMWARE_MOUNT_BOOT
	mkdir -p $(TARGET_DIR)/boot
	grep -q '^/dev/mmcblk1p1' $(TARGET_DIR)/etc/fstab || \
		echo -e '/dev/mmcblk0p1 /boot vfat defaults 0 0' >> $(TARGET_DIR)/etc/fstab
endef
define RPI_FIRMWARE_CMDLINE
	$(INSTALL) -D -m 0644 package/rpi-firmware/cmdline.txt-1 $(BINARIES_DIR)/rpi-firmware/cmdline.txt
endef
else
define RPI_FIRMWARE_MOUNT_BOOT
	mkdir -p $(TARGET_DIR)/boot
	grep -q '^/dev/mmcblk0p1' $(TARGET_DIR)/etc/fstab || \
		echo -e '/dev/mmcblk0p1 /boot vfat defaults 0 0' >> $(TARGET_DIR)/etc/fstab
endef
define RPI_FIRMWARE_CMDLINE
	$(INSTALL) -D -m 0644 package/rpi-firmware/cmdline.txt-0 $(BINARIES_DIR)/rpi-firmware/cmdline.txt
endef
endif

ifeq ($(BR2_TARGET_ROOTFS_CPIO),y)
ifeq ($(BR2_TOOLCHAIN_HEADERS_AT_LEAST_4_14),y)
define RPI_FIRMWARE_MOUNT_ROOT
	mkdir -p $(TARGET_DIR)/root
	grep -q '^/dev/mmcblk1p2' $(TARGET_DIR)/etc/fstab || \
		echo -e '/dev/mmcblk1p2 /root ext4 defaults 0 0' >> $(TARGET_DIR)/etc/fstab
	$(INSTALL) -m 0755 -D package/rpi-firmware/S30mountroot-1 \
		$(TARGET_DIR)/etc/init.d/S30mountroot
endef
else
define RPI_FIRMWARE_MOUNT_ROOT
	mkdir -p $(TARGET_DIR)/root
	grep -q '^/dev/mmcblk0p2' $(TARGET_DIR)/etc/fstab || \
		echo -e '/dev/mmcblk0p2 /root ext4 defaults 0 0' >> $(TARGET_DIR)/etc/fstab
	$(INSTALL) -m 0755 -D package/rpi-firmware/S30mountroot-0 \
		$(TARGET_DIR)/etc/init.d/S30mountroot
endef
endif
endif

ifeq ($(BR2_PACKAGE_RPI_VERSION_RPI4),y)
>>>>>>> origin/master
# bootcode.bin is not used on rpi4, because it has been replaced by boot code in the onboard EEPROM
define RPI_FIRMWARE_INSTALL_BOOT
	$(INSTALL) -D -m 0644 $(@D)/boot/start4$(BR2_PACKAGE_RPI_FIRMWARE_BOOT).elf $(BINARIES_DIR)/rpi-firmware/start4.elf
	$(INSTALL) -D -m 0644 $(@D)/boot/fixup4$(BR2_PACKAGE_RPI_FIRMWARE_BOOT).dat $(BINARIES_DIR)/rpi-firmware/fixup4.dat
endef
else
define RPI_FIRMWARE_INSTALL_BOOT
	$(INSTALL) -D -m 0644 $(@D)/boot/bootcode.bin $(BINARIES_DIR)/rpi-firmware/bootcode.bin
	$(INSTALL) -D -m 0644 $(@D)/boot/start$(BR2_PACKAGE_RPI_FIRMWARE_BOOT).elf $(BINARIES_DIR)/rpi-firmware/start.elf
	$(INSTALL) -D -m 0644 $(@D)/boot/fixup$(BR2_PACKAGE_RPI_FIRMWARE_BOOT).dat $(BINARIES_DIR)/rpi-firmware/fixup.dat
endef
endif

define RPI_FIRMWARE_INSTALL_IMAGES_CMDS
	$(INSTALL) -D -m 0644 package/rpi-firmware/config.txt $(BINARIES_DIR)/rpi-firmware/config.txt
<<<<<<< HEAD
	$(INSTALL) -D -m 0644 package/rpi-firmware/cmdline.txt $(BINARIES_DIR)/rpi-firmware/cmdline.txt
=======
	$(RPI_FIRMWARE_CMDLINE)
	$(RPI_FIRMWARE_MOUNT_BOOT)
	$(RPI_FIRMWARE_MOUNT_ROOT)
>>>>>>> origin/master
	$(RPI_FIRMWARE_INSTALL_BOOT)
	$(RPI_FIRMWARE_INSTALL_DTB)
	$(RPI_FIRMWARE_INSTALL_DTB_OVERLAYS)
endef

$(eval $(generic-package))
