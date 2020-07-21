################################################################################
#
# WPEWebKit
#
################################################################################

ifneq ($(BR2_PACKAGE_WPEWEBKIT_BUILD_CUSTOM_VERSION),"")
WPEWEBKIT_VERSION_VALUE = $(call qstrip,$(BR2_PACKAGE_WPEWEBKIT_BUILD_CUSTOM_VERSION))
# If enabled, choose the development version hash.
else ifeq ($(BR2_PACKAGE_WPEWEBKIT_BUILD_DEVELOPMENT_VERSION),y)
WPEWEBKIT_VERSION_VALUE = 1b1cbd3766f7031ed0e68244bd6b7b6699d9ff91 # wpe-2.22
else
WPEWEBKIT_VERSION_VALUE = e044951cb6a9bf2f6f1c20ec4a6630d05c40a3d6 # wpe-2.22
endif

WPEWEBKIT_VERSION = $(WPEWEBKIT_VERSION_VALUE)
WPEWEBKIT_SITE = $(call github,WebPlatformForEmbedded,WPEWebKit,$(WPEWEBKIT_VERSION))

WPEWEBKIT_INSTALL_STAGING = YES

WPEWEBKIT_BUILD_WEBKIT=y
WPEWEBKIT_BUILD_JSC=n
WPEWEBKIT_USE_PORT=WPE
ifeq ($(BR2_PACKAGE_WPEWEBKIT_JSC),y)
WPEWEBKIT_BUILD_JSC=y
ifeq ($(BR2_PACKAGE_WPEWEBKIT_ONLY_JSC),y)
WPEWEBKIT_BUILD_WEBKIT=n
WPEWEBKIT_USE_PORT=JSCOnly
endif
endif

# wpewebkit binary package config
WPEWEBKIT_OPKG_NAME = "wpewebkit"
WPEWEBKIT_OPKG_VERSION = "0.0.20170728"
WPEWEBKIT_OPKG_ARCHITECTURE = "${BR2_ARCH}"
WPEWEBKIT_OPKG_DEPENDS = ""
WPEWEBKIT_OPKG_MAINTAINER = "Metrological"
WPEWEBKIT_OPKG_PRIORITY = "optional"
WPEWEBKIT_OPKG_SECTION = "graphics"
WPEWEBKIT_OPKG_SOURCE = "${WPEWEBKIT_SITE}"
WPEWEBKIT_OPKG_DESCRIPTION = "This is a description for WPEWebKit package"

WPEWEBKIT_DEPENDENCIES = host-bison host-cmake host-flex host-gperf host-ruby icu pcre

ifeq ($(WPEWEBKIT_BUILD_WEBKIT),y)
WPEWEBKIT_DEPENDENCIES += wpebackend libgcrypt libgles libegl libepoxy cairo freetype \
	fontconfig harfbuzz libxml2 libxslt sqlite libsoup jpeg libpng
endif

WPEWEBKIT_EXTRA_FLAGS = -DCMAKE_EXPORT_COMPILE_COMMANDS=ON

ifeq ($(BR2_PACKAGE_NINJA),y)
WPEWEBKIT_DEPENDENCIES += host-ninja
WPEWEBKIT_EXTRA_FLAGS += \
	-G Ninja
ifeq ($(VERBOSE),1)
WPEWEBKIT_EXTRA_OPTIONS += -v
endif
endif

ifeq ($(BR2_TOOLCHAIN_USES_UCLIBC),y)
WPEWEBKIT_EXTRA_FLAGS += \
	-D__UCLIBC__=ON
endif

ifeq ($(BR2_PACKAGE_LIBINPUT),y)
WPEWEBKIT_DEPENDENCIES += libinput
endif

ifeq ($(WPEWEBKIT_BUILD_WEBKIT),y)
WPEWEBKIT_FLAGS = \
	-DEXPORT_DEPRECATED_WEBKIT2_C_API=ON \
	-DENABLE_ACCELERATED_2D_CANVAS=ON \
	-DENABLE_GEOLOCATION=OFF \
	-DENABLE_DEVICE_ORIENTATION=ON \
	-DENABLE_GAMEPAD=ON \
	-DENABLE_SUBTLE_CRYPTO=ON \
	-DENABLE_FULLSCREEN_API=ON \
	-DENABLE_NOTIFICATIONS=ON \
	-DENABLE_DATABASE_PROCESS=ON \
	-DENABLE_INDEXED_DATABASE=ON \
	-DENABLE_MEDIA_STATISTICS=ON \
	-DENABLE_FETCH_API=ON \
	-DENABLE_WEBDRIVER=ON

ifeq ($(BR2_TOOLCHAIN_USES_MUSL),y)
WPEWEBKIT_FLAGS += -DENABLE_SAMPLING_PROFILER=OFF
else
WPEWEBKIT_FLAGS += -DENABLE_SAMPLING_PROFILER=ON
endif

ifeq ($(BR2_PACKAGE_WEBP),y)
WPEWEBKIT_DEPENDENCIES += webp
endif

ifeq ($(BR2_PACKAGE_WPEWEBKIT_ENABLE_NATIVE_VIDEO),y)
WPEWEBKIT_FLAGS += -DENABLE_NATIVE_VIDEO=ON
else
WPEWEBKIT_FLAGS += -DENABLE_NATIVE_VIDEO=OFF
endif

ifeq ($(BR2_PACKAGE_WPEWEBKIT_ENABLE_NATIVE_AUDIO),y)
WPEWEBKIT_FLAGS += -DENABLE_NATIVE_AUDIO=ON
else
WPEWEBKIT_FLAGS += -DENABLE_NATIVE_AUDIO=OFF
endif

ifeq ($(BR2_PACKAGE_WPEWEBKIT_ENABLE_TEXT_SINK),y)
WPEWEBKIT_FLAGS += -DENABLE_TEXT_SINK=ON
else
WPEWEBKIT_FLAGS += -DENABLE_TEXT_SINK=OFF
endif

ifeq ($(BR2_PACKAGE_GSTREAMER1),y)
WPEWEBKIT_DEPENDENCIES += gstreamer1 gst1-plugins-base gst1-plugins-good gst1-plugins-bad
WPEWEBKIT_FLAGS += \
	-DENABLE_VIDEO=ON \
	-DENABLE_VIDEO_TRACK=ON
else
WPEWEBKIT_FLAGS += \
	-DENABLE_VIDEO=OFF \
	-DENABLE_VIDEO_TRACK=OFF
endif

ifeq ($(BR2_PACKAGE_GST1_PLUGINS_DORNE),y)
WPEWEBKIT_FLAGS += -DENABLE_WEB_AUDIO=OFF
else
ifeq ($(BR2_PACKAGE_WPEWEBKIT_USE_WEB_AUDIO),y)
WPEWEBKIT_FLAGS += -DENABLE_WEB_AUDIO=ON
else
WPEWEBKIT_FLAGS += -DENABLE_WEB_AUDIO=OFF
endif
endif

ifeq ($(BR2_PACKAGE_WPEWEBKIT_ENABLE_MEDIA_SOURCE),y)
WPEWEBKIT_FLAGS += -DENABLE_MEDIA_SOURCE=ON
else
WPEWEBKIT_FLAGS += -DENABLE_MEDIA_SOURCE=OFF
endif

ifeq ($(BR2_PACKAGE_WPEWEBKIT_USE_ENCRYPTED_MEDIA),y)
WPEWEBKIT_FLAGS += -DENABLE_ENCRYPTED_MEDIA=ON
endif

ifeq ($(BR2_PACKAGE_WPEFRAMEWORK_CDM),y)
WPEWEBKIT_DEPENDENCIES += wpeframework
WPEWEBKIT_FLAGS += -DENABLE_OPENCDM=ON
endif

ifeq ($(BR2_PACKAGE_WPEWEBKIT_ENABLE_MEDIA_STREAM),y)
WPEWEBKIT_DEPENDENCIES += openwebrtc
WPEWEBKIT_FLAGS += -DENABLE_MEDIA_STREAM=ON
endif

ifeq ($(BR2_PACKAGE_WPEWEBKIT_USE_GSTREAMER_GL),y)
WPEWEBKIT_FLAGS += -DUSE_GSTREAMER_GL=ON
else
WPEWEBKIT_FLAGS += -DUSE_GSTREAMER_GL=OFF
endif

ifeq ($(BR2_PACKAGE_WPEWEBKIT_USE_GSTREAMER_WEBKIT_HTTP_SRC),y)
WPEWEBKIT_FLAGS += -DUSE_GSTREAMER_WEBKIT_HTTP_SRC=ON
else
WPEWEBKIT_FLAGS += -DUSE_GSTREAMER_WEBKIT_HTTP_SRC=OFF
endif

ifeq ($(BR2_PACKAGE_WPEWEBKIT_USE_FUSION_API),y)
WPEWEBKIT_FLAGS += -DUSE_FUSION_SINK=ON
endif

ifeq ($(BR2_PACKAGE_WPEWEBKIT_USE_PUNCH_HOLE_GSTREAMER),y)
WPEWEBKIT_FLAGS += -DUSE_HOLE_PUNCH_GSTREAMER=ON -DUSE_GSTREAMER_HOLEPUNCH=ON
else ifeq ($(BR2_PACKAGE_WPEWEBKIT_USE_PUNCH_HOLE_EXTERNAL),y)
WPEWEBKIT_FLAGS += -DUSE_HOLE_PUNCH_EXTERNAL=ON -DUSE_EXTERNAL_HOLEPUNCH=ON
endif

endif

ifeq ($(BR2_PACKAGE_WESTEROS),y)
WPEWEBKIT_DEPENDENCIES += westeros
WPEWEBKIT_FLAGS += -DUSE_WPEWEBKIT_PLATFORM_WESTEROS=ON
ifeq ($(BR2_PACKAGE_WESTEROS_SINK),y)
WPEWEBKIT_DEPENDENCIES += westeros-sink
WPEWEBKIT_FLAGS += -DUSE_WESTEROS_SINK=ON -DUSE_HOLE_PUNCH_GSTREAMER=ON -DUSE_GSTREAMER_HOLEPUNCH=ON
else
WPEWEBKIT_FLAGS += -DUSE_HOLE_PUNCH_GSTREAMER=OFF -DUSE_GSTREAMER_HOLEPUNCH=OFF
endif
else ifeq ($(BR2_PACKAGE_HAS_NEXUS),y)
WPEWEBKIT_FLAGS += -DUSE_WPEWEBKIT_PLATFORM_BCM_NEXUS=ON
else ifeq ($(BR2_PACKAGE_HORIZON_SDK),y)
WPEWEBKIT_FLAGS += -DUSE_WPEWEBKIT_PLATFORM_INTEL_CE=ON
else ifeq ($(BR2_PACKAGE_INTELCE_SDK),y)
WPEWEBKIT_FLAGS += -DUSE_WPEWEBKIT_PLATFORM_INTEL_CE=ON
else ifeq ($(BR2_PACKAGE_RPI_FIRMWARE),y)
WPEWEBKIT_FLAGS += -DUSE_WPEWEBKIT_PLATFORM_RPI=ON
endif

ifeq ($(BR2_PACKAGE_VSS_SDK),y)
WPEWEBKIT_FLAGS += \
	-DENABLE_ACCELERATED_2D_CANVAS=OFF \
	-DENABLE_WEB_CRYPTO=OFF
endif

ifeq ($(BR2_PACKAGE_WPEWEBKIT_ONLY_JSC), y)
WPEWEBKIT_FLAGS += -DENABLE_STATIC_JSC=ON
endif

ifeq ($(BR2_PACKAGE_WPEWEBKIT_DEBUG)$(BR2_PACKAGE_WPEWEBKIT_SYMBOLS),y)
WPEWEBKIT_SYMBOL_FLAGS = -g
endif

WPEWEBKIT_BUILD_TYPE = Release
WPEWEBKIT_DEBUG_BUILD_FLAGS = -O2 -DNDEBUG
ifeq ($(BR2_PACKAGE_WPEWEBKIT_DEBUG),y)
WPEWEBKIT_BUILD_TYPE = Debug
WPEWEBKIT_FLAGS += -DCMAKE_BUILD_TYPE=Debug
WPEWEBKIT_DEBUG_BUILD_FLAGS = -O0
endif

ifeq ($(BR2_PACKAGE_WPEWEBKIT_NO_JSC_OPTIMIZATIONS),y)
WPEWEBKIT_FLAGS += -DENABLE_JIT=OFF -DENABLE_FTL_JIT=OFF
endif

ifeq ($(BR2_PACKAGE_WPEWEBKIT_USE_GOLD_LD),y)
WPEWEBKIT_FLAGS += -DUSE_LD_GOLD=ON
ifeq ($(BR2_BINUTILS_VERSION_2_25_X)$(BR2_BINUTILS_VERSION_2_26_X)$(BR2_PACKAGE_WPEWEBKIT_DEBUG),yy)
WPEWEBKIT_EXTRA_FLAGS += -DDEBUG_FISSION=TRUE
endif
endif

WPEWEBKIT_EXTRA_FLAGS += \
	-DCMAKE_C_FLAGS_RELEASE="$(WPEWEBKIT_SYMBOL_FLAGS) $(WPEWEBKIT_DEBUG_BUILD_FLAGS) -Wno-cast-align" \
	-DCMAKE_CXX_FLAGS_RELEASE="$(WPEWEBKIT_SYMBOL_FLAGS) $(WPEWEBKIT_DEBUG_BUILD_FLAGS) -Wno-cast-align" \
	-DCMAKE_C_FLAGS_DEBUG="$(WPEWEBKIT_SYMBOL_FLAGS) $(WPEWEBKIT_DEBUG_BUILD_FLAGS) -Wno-cast-align" \
	-DCMAKE_CXX_FLAGS_DEBUG="$(WPEWEBKIT_SYMBOL_FLAGS) $(WPEWEBKIT_DEBUG_BUILD_FLAGS) -Wno-cast-align"

WPEWEBKIT_CONF_OPTS = \
	-DPORT=$(WPEWEBKIT_USE_PORT) \
	$(WPEWEBKIT_EXTRA_FLAGS) \
	$(WPEWEBKIT_FLAGS)

WPEWEBKIT_BUILDDIR = $(@D)/build-$(WPEWEBKIT_BUILD_TYPE)

ifeq ($(BR2_PACKAGE_NINJA),y)

WPEWEBKIT_BUILD_TARGETS=
ifeq ($(WPEWEBKIT_BUILD_JSC),y)
WPEWEBKIT_BUILD_TARGETS += jsc
endif
ifeq ($(WPEWEBKIT_BUILD_WEBKIT),y)
WPEWEBKIT_BUILD_TARGETS += all

endif

define WPEWEBKIT_BUILD_CMDS
	$(TARGET_MAKE_ENV) $(HOST_DIR)/usr/bin/ninja -C $(WPEWEBKIT_BUILDDIR) $(WPEWEBKIT_EXTRA_OPTIONS) $(WPEWEBKIT_BUILD_TARGETS)
endef

ifeq ($(WPEWEBKIT_BUILD_JSC),y)
define WPEWEBKIT_INSTALL_STAGING_CMDS_JSC
	pushd $(WPEWEBKIT_BUILDDIR) && \
	cp bin/jsc $(STAGING_DIR)/usr/bin/ && \
	popd > /dev/null
endef
else
WPEWEBKIT_INSTALL_STAGING_CMDS_JSC = true
endif

ifeq ($(WPEWEBKIT_BUILD_WEBKIT),y)
define WPEWEBKIT_INSTALL_STAGING_CMDS_WEBKIT
	cp $(WPEWEBKIT_BUILDDIR)/bin/WPE{Network,Storage,Web}Process $(STAGING_DIR)/usr/bin/ && \
	cp $(WPEWEBKIT_BUILDDIR)/bin/WPEWebDriver $(STAGING_DIR)/usr/bin/ && \
	cp -d $(WPEWEBKIT_BUILDDIR)/lib/libWPE* $(STAGING_DIR)/usr/lib/ && \
	DESTDIR=$(STAGING_DIR) $(HOST_DIR)/usr/bin/cmake -DCOMPONENT=Development -P $(WPEWEBKIT_BUILDDIR)/Source/JavaScriptCore/cmake_install.cmake > /dev/null && \
	DESTDIR=$(STAGING_DIR) $(HOST_DIR)/usr/bin/cmake -DCOMPONENT=Development -P $(WPEWEBKIT_BUILDDIR)/Source/WebKit/cmake_install.cmake > /dev/null
endef
else
WPEWEBKIT_INSTALL_STAGING_CMDS_WEBKIT = true
endif

define WPEWEBKIT_INSTALL_STAGING_CMDS
	($(WPEWEBKIT_INSTALL_STAGING_CMDS_JSC) && \
	$(WPEWEBKIT_INSTALL_STAGING_CMDS_WEBKIT))
endef

ifeq ($(WPEWEBKIT_BUILD_JSC),y)
define WPEWEBKIT_INSTALL_TARGET_CMDS_JSC
	$(INSTALL) -d $(TARGET_DIR)/usr/bin/ && \
	cp $(WPEWEBKIT_BUILDDIR)/bin/jsc $(TARGET_DIR)/usr/bin/ && \
	$(STRIPCMD) $(TARGET_DIR)/usr/bin/jsc
endef
else
WPEWEBKIT_INSTALL_TARGET_CMDS_JSC = true
endif

ifeq ($(WPEWEBKIT_BUILD_WEBKIT),y)
define WPEWEBKIT_INSTALL_TARGET_CMDS_WEBKIT
	$(INSTALL) -d $(TARGET_DIR)/usr/bin/ && \
	cp $(WPEWEBKIT_BUILDDIR)/bin/WPE{Network,Storage,Web}Process $(TARGET_DIR)/usr/bin/ && \
	cp $(WPEWEBKIT_BUILDDIR)/bin/WPEWebDriver $(TARGET_DIR)/usr/bin/ && \
	$(INSTALL) -d $(TARGET_DIR)/usr/lib/ && \
	cp -d $(WPEWEBKIT_BUILDDIR)/lib/libWPE* $(TARGET_DIR)/usr/lib/ && \
	$(STRIPCMD) $(TARGET_DIR)/usr/lib/libWPEWebKit*.so.*
endef
else
WPEWEBKIT_INSTALL_TARGET_CMDS_WEBKIT = true
endif

ifeq ($(BR2_PACKAGE_WPEFRAMEWORK_CREATE_IPKG_TARGETS),y)

WPEWEBKIT_DEPENDENCIES += ${SIMPLE_OPKG_TOOLS_DEPENDENCIES}

define WPEWEBKIT_INSTALL_TARGET_CMDS
	@# prepare package metadata
	$(call SIMPLE_OPKG_TOOLS_INIT,WPEWEBKIT,${@D})

	@# set install target
	$(call SIMPLE_OPKG_TOOLS_SET_TARGET,WPEWEBKIT,${@D})

	@# install target files
	($(WPEWEBKIT_INSTALL_TARGET_CMDS_JSC) && \
	$(WPEWEBKIT_INSTALL_TARGET_CMDS_WEBKIT))

	@# build package
	$(call SIMPLE_OPKG_TOOLS_BUILD_PACKAGE,${@D})

	@# install package
	$(call SIMPLE_OPKG_TOOLS_INSTALL_PACKAGE,${@D}/${WPEWEBKIT_OPKG_NAME}_${WPEWEBKIT_OPKG_VERSION}_${WPEWEBKIT_OPKG_ARCHITECTURE}.ipk)

	@# set previous TARGET_DIR
	$(call SIMPLE_OPKG_TOOLS_UNSET_TARGET,WPEWEBKIT)
endef
else # ($(BR2_PACKAGE_WPEFRAMEWORK_CREATE_IPKG_TARGETS),y)
define WPEWEBKIT_INSTALL_TARGET_CMDS
	($(WPEWEBKIT_INSTALL_TARGET_CMDS_JSC) && \
	$(WPEWEBKIT_INSTALL_TARGET_CMDS_WEBKIT))
endef
endif # ($(BR2_PACKAGE_WPEFRAMEWORK_CREATE_IPKG_TARGETS),y)
endif

RSYNC_VCS_EXCLUSIONS += --exclude LayoutTests --exclude WebKitBuild

# Temporary fix for vss platforms
ifeq ($(BR2_PACKAGE_VSS_SDK_MOVE_GSTREAMER),y)
WPEWEBKIT_PKGDIR = "$(TOP_DIR)/package/wpe/wpewebkit"

define WPEWEBKIT_APPLY_LOCAL_PATCHES
 # this platform needs to run this gstreamer version parallel
 # to an older version.
 $(APPLY_PATCHES) $(@D) $(WPEWEBKIT_PKGDIR) 9999-link_to_wpe_gstreamer.patch.conditional
endef
WPEWEBKIT_POST_PATCH_HOOKS += WPEWEBKIT_APPLY_LOCAL_PATCHES
endif

$(eval $(cmake-package))
