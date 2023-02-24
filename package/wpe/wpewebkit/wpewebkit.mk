################################################################################
#
# WPEWebKit
#
################################################################################

ifeq ($(BR2_PACKAGE_WPEWEBKIT2_22),y)
WPEWEBKIT_VERSION = 2.22
WPEWEBKIT_VERSION_VALUE = 4a3f5e45a87edf439e9d1dfe919e2137972d1bfe
endif

ifeq ($(BR2_PACKAGE_WPEWEBKIT2_28),y)
WPEWEBKIT_VERSION = 2.28
WPEWEBKIT_VERSION_VALUE = e66cae2d3edad330166725dabf1dd79074a2b89b
endif

ifeq ($(BR2_PACKAGE_WPEWEBKIT2_38),y)
WPEWEBKIT_VERSION = 2.38
WPEWEBKIT_VERSION_VALUE = 5da6f8c4c0ce16b8c694b5acd2c3d0c5379f710f
endif

WPEWEBKIT_SITE = $(call github,WebPlatformForEmbedded,WPEWebKit,$(WPEWEBKIT_VERSION_VALUE))

WPEWEBKIT_INSTALL_STAGING = YES
WPEWEBKIT_LICENSE = LGPL-2.1+, BSD-2-Clause
WPEWEBKIT_LICENSE_FILES = \
	Source/WebCore/LICENSE-APPLE \
	Source/WebCore/LICENSE-LGPL-2.1

WPEWEBKIT_DEPENDENCIES = host-gperf host-ninja host-python host-ruby \
	harfbuzz cairo icu jpeg libepoxy libgcrypt libgles libsoup libtasn1 \
	libpng libxslt openjpeg webp wpebackend

WPEWEBKIT_CONF_OPTS = \
	-GNinja \
	-DPORT=WPE \
	-DCMAKE_EXPORT_COMPILE_COMMANDS=ON

ifeq ($(BR2_PACKAGE_WPEWEBKIT2_22)$(BR2_PACKAGE_WPEWEBKIT2_28),y)
WPEWEBKIT_CONF_OPTS += \
	-DENABLE_ACCELERATED_2D_CANVAS=ON
endif

ifeq ($(BR2_PACKAGE_WPEWEBKIT2_28),y)
WPEWEBKIT_CONF_OPTS += \
	-DSILENCE_CROSS_COMPILATION_NOTICES=ON
endif

ifeq ($(BR2_PACKAGE_WPEWEBKIT2_28)$(BR2_PACKAGE_WPEWEBKIT2_38),y)
WPEWEBKIT_CONF_OPTS += \
	-DENABLE_ACCESSIBILITY=OFF \
	-DENABLE_API_TESTS=OFF \
	-DENABLE_BUBBLEWRAP_SANDBOX=OFF \
	-DENABLE_MINIBROWSER=OFF \
	-DUSE_WOFF2=OFF
endif

ifeq ($(BR2_PACKAGE_WPEWEBKIT2_22),y)
WPEWEBKIT_CONF_OPTS += \
	-DENABLE_DATABASE_PROCESS=OFF \
	-DENABLE_DEVICE_ORIENTATION=OFF \
	-DENABLE_FETCH_API=OFF \
	-DENABLE_FTL_JIT=OFF \
	-DENABLE_FULLSCREEN_API=OFF \
	-DENABLE_GAMEPAD=OFF \
	-DENABLE_GEOLOCATION=OFF \
	-DENABLE_INDEXED_DATABASE=OFF \
	-DENABLE_MATHML=OFF \
	-DENABLE_MEDIA_STATISTICS=OFF \
	-DENABLE_METER_ELEMENT=OFF \
	-DENABLE_NOTIFICATIONS=OFF \
	-DENABLE_SAMPLING_PROFILER=ON \
	-DENABLE_SUBTLE_CRYPTO=OFF \
	-DENABLE_SVG_FONTS=OFF \
	-DENABLE_TOUCH_EVENTS=OFF \
	-DENABLE_VIDEO=ON \
	-DENABLE_VIDEO_TRACK=ON \
	-DENABLE_WEBASSEMBLY=OFF \
	-DEXPORT_DEPRECATED_WEBKIT2_C_API=ON
WPEWEBKIT_DEPENDENCIES += gstreamer1 gst1-plugins-base \
	gst1-plugins-good gst1-plugins-bad

ifeq ($(BR2_PACKAGE_WPEWEBKIT_ENABLE_NATIVE_VIDEO),y)
WPEWEBKIT_CONF_OPTS += -DENABLE_NATIVE_VIDEO=ON
else
WPEWEBKIT_CONF_OPTS += -DENABLE_NATIVE_VIDEO=OFF
endif

ifeq ($(BR2_PACKAGE_WPEWEBKIT_ENABLE_NATIVE_AUDIO),y)
WPEWEBKIT_CONF_OPTS += -DENABLE_NATIVE_AUDIO=ON
else
WPEWEBKIT_CONF_OPTS += -DENABLE_NATIVE_AUDIO=OFF
endif

ifeq ($(BR2_PACKAGE_WPEWEBKIT_ENABLE_TEXT_SINK),y)
WPEWEBKIT_CONF_OPTS += -DENABLE_TEXT_SINK=ON
else
WPEWEBKIT_CONF_OPTS += -DENABLE_TEXT_SINK=OFF
endif

ifeq ($(BR2_PACKAGE_WPEWEBKIT_USE_WEB_AUDIO),y)
WPEWEBKIT_CONF_OPTS += -DENABLE_WEB_AUDIO=ON
else
WPEWEBKIT_CONF_OPTS += -DENABLE_WEB_AUDIO=OFF
endif

ifeq ($(BR2_PACKAGE_WPEWEBKIT_ENABLE_MEDIA_SOURCE),y)
WPEWEBKIT_CONF_OPTS += -DENABLE_MEDIA_SOURCE=ON
else
WPEWEBKIT_CONF_OPTS += -DENABLE_MEDIA_SOURCE=OFF
endif

ifeq ($(BR2_PACKAGE_WPEWEBKIT_USE_ENCRYPTED_MEDIA),y)
WPEWEBKIT_CONF_OPTS += -DENABLE_ENCRYPTED_MEDIA=ON
endif

ifeq ($(BR2_PACKAGE_WPEFRAMEWORK_CDM),y)
WPEWEBKIT_DEPENDENCIES += wpeframework-clientlibraries
WPEWEBKIT_CONF_OPTS += -DENABLE_OPENCDM=ON
endif

ifeq ($(BR2_PACKAGE_WPEWEBKIT_USE_GSTREAMER_GL),y)
WPEWEBKIT_CONF_OPTS += -DUSE_GSTREAMER_GL=ON
else
WPEWEBKIT_CONF_OPTS += -DUSE_GSTREAMER_GL=OFF
endif

ifeq ($(BR2_PACKAGE_WPEWEBKIT_USE_GSTREAMER_WEBKIT_HTTP_SRC),y)
WPEWEBKIT_CONF_OPTS += -DUSE_GSTREAMER_WEBKIT_HTTP_SRC=ON
else
WPEWEBKIT_CONF_OPTS += -DUSE_GSTREAMER_WEBKIT_HTTP_SRC=OFF
endif

endif

ifeq ($(BR2_PACKAGE_WPEWEBKIT2_28)$(BR2_PACKAGE_WPEWEBKIT2_38),y)

ifeq ($(BR2_PACKAGE_WPEWEBKIT_MULTIMEDIA),y)
WPEWEBKIT_CONF_OPTS += \
	-DENABLE_VIDEO=ON \
	-DENABLE_MEDIA_SOURCE=ON \
	-DENABLE_ENCRYPTED_MEDIA=ON \
	-DENABLE_MEDIA_STATISTICS=ON \
	-DENABLE_WEB_AUDIO=ON
WPEWEBKIT_DEPENDENCIES += gstreamer1 gst1-plugins-base gst1-plugins-good

ifeq ($(BR2_PACKAGE_WPEFRAMEWORK_CLIENTLIBRARIES)$(BR2_PACKAGE_WPEFRAMEWORK_CDM),yy)
WPEWEBKIT_DEPENDENCIES += wpeframework-clientlibraries
WPEWEBKIT_CONF_OPTS += -DENABLE_THUNDER=ON
else
WPEWEBKIT_CONF_OPTS += -DENABLE_THUNDER=OFF
endif

else
WPEWEBKIT_CONF_OPTS += \
	-DENABLE_VIDEO=OFF \
	-DENABLE_MEDIA_SOURCE=OFF \
	-DENABLE_ENCRYPTED_MEDIA=OFF \
	-DENABLE_THUNDER=OFF \
	-DENABLE_WEB_AUDIO=OFF
endif

ifeq ($(BR2_PACKAGE_WPEWEBKIT_USE_GSTREAMER_GL),y)
WPEWEBKIT_CONF_OPTS += -DUSE_GSTREAMER_GL=ON
else
WPEWEBKIT_CONF_OPTS += -DUSE_GSTREAMER_GL=OFF
endif

endif

ifeq ($(BR2_PACKAGE_WPEWEBKIT2_38),y)
WPEWEBKIT_CONF_OPTS += \
	-DENABLE_GAMEPAD=ON \
	-DENABLE_INTROSPECTION=OFF \
	-DUSE_LCMS=OFF

ifeq ($(BR2_PACKAGE_SYSTEMD),y)
WPEWEBKIT_CONF_OPTS += -DENABLE_JOURNALD_LOG=ON
else
WPEWEBKIT_CONF_OPTS += -DENABLE_JOURNALD_LOG=OFF
endif

ifeq ($(BR2_PACKAGE_WPEWEBKIT_ENABLE_NATIVE_VIDEO),y)
WPEWEBKIT_CONF_OPTS += -DUSE_GSTREAMER_NATIVE_VIDEO=ON
else
WPEWEBKIT_CONF_OPTS += -DUSE_GSTREAMER_NATIVE_VIDEO=OFF
endif

ifeq ($(BR2_PACKAGE_WPEWEBKIT_ENABLE_NATIVE_AUDIO),y)
WPEWEBKIT_CONF_OPTS += -DUSE_GSTREAMER_NATIVE_AUDIO=ON
else
WPEWEBKIT_CONF_OPTS += -DUSE_GSTREAMER_NATIVE_AUDIO=OFF
endif

endif

ifeq ($(BR2_PACKAGE_WPEWEBKIT_SYMBOLS_NO),y)
WPEWEBKIT_SYMBOL_FLAGS = -g0
else ifeq ($(BR2_PACKAGE_WPEWEBKIT_SYMBOLS_LEVEL_1),y)
WPEWEBKIT_SYMBOL_FLAGS = -g1 -gsplit-dwarf
else ifeq ($(BR2_PACKAGE_WPEWEBKIT_SYMBOLS_LEVEL_2),y)
WPEWEBKIT_SYMBOL_FLAGS = -g2 -gsplit-dwarf
else ifeq ($(BR2_PACKAGE_WPEWEBKIT_SYMBOLS_LEVEL_3),y)
WPEWEBKIT_SYMBOL_FLAGS = -g3 -gsplit-dwarf
endif

WPEWEBKIT_BUILD_TYPE = Release
WPEWEBKIT_CXXFLAGS = -O2 -DNDEBUG
ifeq ($(BR2_PACKAGE_WPEWEBKIT_DEBUG),y)
WPEWEBKIT_BUILD_TYPE = Debug
WPEWEBKIT_CONF_OPTS += -DCMAKE_BUILD_TYPE=Debug
WPEWEBKIT_CXXFLAGS = -O0
endif

WPEWEBKIT_COMPILER_FLAGS=$(WPEWEBKIT_SYMBOL_FLAGS) $(WPEWEBKIT_CXXFLAGS) -Wno-cast-align
WPEWEBKIT_CONF_OPTS += \
	-DCMAKE_C_FLAGS_RELEASE="$(WPEWEBKIT_COMPILER_FLAGS)" \
	-DCMAKE_CXX_FLAGS_RELEASE="$(WPEWEBKIT_COMPILER_FLAGS)" \
	-DCMAKE_C_FLAGS_DEBUG="$(WPEWEBKIT_COMPILER_FLAGS)" \
	-DCMAKE_CXX_FLAGS_DEBUG="$(WPEWEBKIT_COMPILER_FLAGS)"

ifeq ($(BR2_PACKAGE_WPEWEBKIT_USE_PUNCH_HOLE_GSTREAMER),y)
WPEWEBKIT_CONF_OPTS += -DUSE_HOLE_PUNCH_GSTREAMER=ON -DUSE_GSTREAMER_HOLEPUNCH=ON
else ifeq ($(BR2_PACKAGE_WPEWEBKIT_USE_PUNCH_HOLE_EXTERNAL),y)
WPEWEBKIT_CONF_OPTS += -DUSE_HOLE_PUNCH_EXTERNAL=ON -DUSE_EXTERNAL_HOLEPUNCH=ON
endif

ifeq ($(BR2_PACKAGE_WPEWEBKIT_WEBDRIVER),y)
WPEWEBKIT_CONF_OPTS += -DENABLE_WEBDRIVER=ON
else
WPEWEBKIT_CONF_OPTS += -DENABLE_WEBDRIVER=OFF
endif

ifeq ($(BR2_PACKAGE_WESTEROS),y)
WPEWEBKIT_DEPENDENCIES += westeros
WPEWEBKIT_CONF_OPTS += -DUSE_WPEWEBKIT_PLATFORM_WESTEROS=ON
ifeq ($(BR2_PACKAGE_WESTEROS_SINK),y)
WPEWEBKIT_DEPENDENCIES += westeros-sink
WPEWEBKIT_CONF_OPTS += \
	-DUSE_GSTREAMER_HOLEPUNCH=ON \
	-DUSE_HOLE_PUNCH_GSTREAMER=ON \
	-DUSE_WESTEROS_SINK=ON
else
WPEWEBKIT_CONF_OPTS += \
	-DUSE_GSTREAMER_HOLEPUNCH=OFF \
	-DUSE_HOLE_PUNCH_GSTREAMER=OFF
endif
else ifeq ($(BR2_PACKAGE_HAS_NEXUS),y)
WPEWEBKIT_CONF_OPTS += -DUSE_WPEWEBKIT_PLATFORM_BCM_NEXUS=ON
else ifeq ($(BR2_PACKAGE_HORIZON_SDK),y)
WPEWEBKIT_CONF_OPTS += -DUSE_WPEWEBKIT_PLATFORM_INTEL_CE=ON
else ifeq ($(BR2_PACKAGE_INTELCE_SDK),y)
WPEWEBKIT_CONF_OPTS += -DUSE_WPEWEBKIT_PLATFORM_INTEL_CE=ON
else ifeq ($(BR2_PACKAGE_RPI_FIRMWARE),y)
WPEWEBKIT_CONF_OPTS += -DUSE_WPEWEBKIT_PLATFORM_RPI=ON
endif

define WPEWEBKIT_BUILD_CMDS
	$(TARGET_MAKE_ENV) $(WPEWEBKIT_NINJA_ENV) \
		$(BR2_CMAKE) --build $(WPEWEBKIT_BUILDDIR) -- $(NINJA_OPTS) $(WPEWEBKIT_NINJA_OPTS)
endef

define WPEWEBKIT_INSTALL_CMDS
	$(TARGET_MAKE_ENV) $(WPEWEBKIT_NINJA_ENV) \
		$(BR2_CMAKE) --install $(WPEWEBKIT_BUILDDIR)
endef

define WPEWEBKIT_INSTALL_STAGING_CMDS
	$(TARGET_MAKE_ENV) $(WPEWEBKIT_NINJA_ENV) DESTDIR=$(STAGING_DIR) \
		$(BR2_CMAKE) --install $(WPEWEBKIT_BUILDDIR)
endef

define WPEWEBKIT_INSTALL_TARGET_CMDS
	$(TARGET_MAKE_ENV) $(WPEWEBKIT_MAKE_ENV) DESTDIR=$(TARGET_DIR) \
		$(BR2_CMAKE) --install $(WPEWEBKIT_BUILDDIR)
endef

$(eval $(cmake-package))
