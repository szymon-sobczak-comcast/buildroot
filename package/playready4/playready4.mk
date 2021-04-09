################################################################################
#
# Playready v4
#
################################################################################

PLAYREADY4_VERSION = c69985cf4fec742d2ff77fc73699c8fb860be585
PLAYREADY4_SITE = git@github.com:Metrological/playready.git
PLAYREADY4_SITE_METHOD = git
PLAYREADY4_LICENSE = PROPRIETARY
PLAYREADY4_DEPENDENCIES += libcurl
PLAYREADY4_INSTALL_STAGING = YES
PLAYREADY4_INSTALL_TARGET = YES
PLAYREADY4_SUBDIR = "source/linux"
PLAYREADY4_MAKE=$(MAKE1)
PLAYREADY_USE_PROVISION = "OFF"

ifeq ($(BR2_PACKAGE_WPEFRAMEWORK_PROVISIONPROXY), y)
    PLAYREADY_USE_PROVISION = "ON"
    PLAYREADY_DEPENDENCIES += wpeframework-clientlibraries
endif


# Generic Buildroot
# Parallel build issues, Use MAKE1 to disable parallel
define PLAYREADY4_BUILD_CMDS
        ulimit -n 4096; \
        export PLAYREADY_DIR="$(@D)/$(PLAYREADY4_SUBDIR)";\
	export PLAYREADY_ROOT="$(@D)";\
	export PLAYREADY_PROFILE="drmprofilelinux.mk";\
	export LINUX_BUILD="1";\
	$(TARGET_MAKE_ENV) $(MAKE1) PLAYREADY_GXX=$(TARGET_CC) \
                                    CC=$(TARGET_CC) \
				    PLAYREADY_USE_PROVISION=$(PLAYREADY_USE_PROVISION) \
				    LIBPATHS=" -L$(STAGING_DIR)/usr/lib " \
                                    AR=$(TARGET_AR) \
				    PLAYREADY_PKGCONFIG="$(PKG_CONFIG_HOST_BINARY)" \
				    PLAYREADY_BUILD_TYPE="CHK" \
                                    MACHINE=$(KERNEL_ARCH) -C $(@D)/source;
endef

PLAYREADY4_DATA_DIR=/etc/playready

define PLAYREADY4_INSTALL
	echo "INSTALLING PLAYREADY4*********" ;

        $(INSTALL) -d $(1)/usr/lib
        $(INSTALL) -D -m 0755 $(@D)/bin/exe/prdy_test.exe $(1)/usr/bin/prdy_test.exe
        $(INSTALL) -D -m 0755 $(@D)/bin/lib/libplayready.so $(1)/usr/lib/libplayready.so

        $(INSTALL) -d $(1)$(PLAYREADY4_DATA_DIR)
endef

define PLAYREADY4_INSTALL_DEV
	echo "INSTALLING PLAYREADY4 DEV*********" ;

        $(call PLAYREADY4_INSTALL, $(1))

        $(INSTALL) -d $(1)/usr/lib/pkgconfig
        $(INSTALL) -D package/playready4/playready.pc $(1)/usr/lib/pkgconfig/playready.pc

        $(INSTALL) -d $(1)/usr/include/playready
        cp -a $(@D)/source/inc/* $(1)/usr/include/playready

        $(INSTALL) -d $(1)/usr/include/playready/oem/common
	cp -a $(@D)/source/oem/common/inc/*.h $(1)/usr/include/playready/oem/common

        $(INSTALL) -d $(1)/usr/include/playready/oem/ansi
        cp -a $(@D)/source/oem/ansi/inc/*.h $(1)/usr/include/playready/oem/ansi
         
	cp -a $(@D)/source/results/*.h $(1)/usr/include/playready
endef

define PLAYREADY4_INSTALL_STAGING_CMDS
        echo "INSTALLING STAGING PLAYREADY4*********" ;
        $(call PLAYREADY4_INSTALL_DEV, ${STAGING_DIR})
endef

define PLAYREADY4_INSTALL_TARGET_CMDS
        echo "INSTALLING STAGING PLAYREADY4*********" ;
        $(call PLAYREADY4_INSTALL, ${TARGET_DIR})
endef

define PLAYREADY4_INSTALL_TARGET_ETC_PLAYREADY
        echo "INSTALLING ETC PLAYREADY4*********" ;
        ln -sf /tmp $(TARGET_DIR)/etc/playready/storage
endef

PLAYREADY4_POST_INSTALL_TARGET_HOOKS += PLAYREADY4_INSTALL_TARGET_ETC_PLAYREADY

# It's not autotools-based
$(eval $(generic-package))
