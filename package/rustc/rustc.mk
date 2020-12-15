################################################################################
#
# rustc
#
################################################################################

<<<<<<< HEAD
RUSTC_ARCH = $(call qstrip,$(BR2_PACKAGE_HOST_RUSTC_ARCH))
RUSTC_ABI = $(call qstrip,$(BR2_PACKAGE_HOST_RUSTC_ABI))

ifeq ($(BR2_PACKAGE_HOST_RUSTC_TARGET_ARCH_SUPPORTS),y)
RUSTC_TARGET_NAME = $(RUSTC_ARCH)-unknown-linux-gnu$(RUSTC_ABI)
endif

ifeq ($(HOSTARCH),x86)
RUSTC_HOST_ARCH = i686
else
RUSTC_HOST_ARCH = $(HOSTARCH)
endif

RUSTC_HOST_NAME = $(RUSTC_HOST_ARCH)-unknown-linux-gnu
=======
RUST_TARGET_NAME := $(subst buildroot,unknown,$(GNU_TARGET_NAME))

ifeq ($(BR2_ARM_CPU_ARMV7A),y)
RUST_TARGET_NAME := $(subst arm-,armv7-,$(RUST_TARGET_NAME))
endif

ifeq ($(HOSTARCH),x86_64)
RUST_HOST_ARCH = x86_64
else ifeq ($(HOSTARCH),x86)
RUST_HOST_ARCH = i686
endif

RUST_HOST_NAME = $(RUST_HOST_ARCH)-unknown-linux-gnu
>>>>>>> origin/master

$(eval $(host-virtual-package))
