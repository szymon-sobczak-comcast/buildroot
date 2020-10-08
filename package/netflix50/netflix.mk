################################################################################
#
# netflix (NRDP)
#
################################################################################
NETFLIX50_SITE = git@github.com:Metrological/netflix.git
NETFLIX50_VERSION = aefe77db514724bc9db1626f1f09f285a6ad5232
NETFLIX50_SITE_METHOD = git
NETFLIX50_LICENSE = PROPRIETARY
NETFLIX50_INSTALL_TARGET = YES
NETFLIX50_SUPPORTS_IN_SOURCE_BUILD = NO
NETFLIX50_SUBDIR = netflix
NETFLIX50_DEPENDENCIES = \
	c-ares \
	expat \
	freetype \
	harfbuzz \
	icu \
	jpeg \
	libcurl \
	libmng \
	libnl \
	libpng \
	nghttp2 \
	openssl \
	webp \
	zlib \
	gstreamer1 \
	gst1-plugins-base \
	gst1-plugins-bad \
	gst1-libav \
	libgles \
	libegl
	# TODO: seems like they are not needed
	# fdk-aac \
	# graphite2 \
	# lcms2 \
	# libopenh264 \
	# openjpeg \

NETFLIX50_RESOURCE_LOC = $(call qstrip,${BR2_PACKAGE_NETFLIX50_RESOURCE_LOCATION})
NETFLIX50_CONF_ENV += \
	TOOLCHAIN_DIRECTORY=$(STAGING_DIR)/usr \
	LD=$(TARGET_CROSS)ld \
	OBJCOPY=$(TARGET_CROSS)objcopy \
	STRIP=$(TARGET_CROSS)strip \
	TARGET_CROSS="$(GNU_TARGET_NAME)-"

NETFLIX50_CONF_OPTS += -DBUILD_REFERENCE=${NETFLIX50_VERSION}

NETFLIX50_CONF_OPTS += \
	-DCMAKE_INSTALL_PREFIX=$(@D)/release \
	-DNRDP_SYSTEM_PROCESSOR=$(BR2_ARCH) \
	-DNRDP_HAS_SOFTWAREPLAYER=ON \
	-DGIBBON_SOFTWARECAPTURE=OFF \
	-DGIBBON_GRAPHICS_GL_API="gles2" \
	-DBUILD_DPI_DIRECTORY=$(@D)/partner/dpi \
	-DCMAKE_OBJCOPY="$(TARGET_CROSS)objcopy" \
	-DCMAKE_STRIP="$(TARGET_CROSS)strip" \
	-DBUILD_COMPILE_RESOURCES=OFF \
	-DBUILD_SHARED_LIBS=OFF \
	-DNRDP_HAS_IPV6=ON \
	-DGIBBON_GRAPHICS_GL_WSYS=egl \
	-DGIBBON_FONTS="-all" \
	-DBUILD_GIBBON_DIRECTORY=$(@D)/partner/ \
	-DDPI_REFERENCE_DRM="null" \
	-DDPI_IMPLEMENTATION=gstreamer

NETFLIX50_CONF_ENV += \
	NODE="$(HOST_DIR)/usr/bin/node" \
	NPM="$(HOST_DIR)/usr/bin/npm" \

ifeq ($(BR2_PACKAGE_NETFLIX50_BUILD_ML),y)
NETFLIX50_CONF_OPTS += \
	-DBUILD_COMPILE_RESOURCES=ON \
	-DNRDP_CRASH_REPORTING=breakpad \
	-DBUILD_DEBUG=OFF \
	-DNRDP_HAS_GIBBON_QA=ON \
	-DNRDP_HAS_MUTEX_STACK=ON \
	-DNRDP_HAS_OBJECTCOUNT=ON \
	-DBUILD_PRODUCTION=OFF \
	-DNRDP_HAS_QA=OFF \
	-DBUILD_SMALL=OFF \
	-DBUILD_SYMBOLS=ON \
	-DNRDP_HAS_TRACING=OFF
else ifeq ($(BR2_PACKAGE_NETFLIX50_BUILD_DEBUG),y)
NETFLIX50_CONF_OPTS += \
	-DBUILD_DEBUG=ON \
	-DBUILD_SMALL=OFF \
	-DBUILD_STRIP=OFF \
	-DBUILD_SYMBOLS=ON \
	-DBUILD_PRODUCTION=OFF \
	-DNRDP_HAS_GIBBON_QA=ON \
	-DNRDP_HAS_MUTEX_STACK=ON \
	-DNRDP_HAS_OBJECTCOUNT=ON \
	-DNRDP_HAS_QA=ON \
	-DNRDP_HAS_TRACING=ON
else ifeq ($(BR2_PACKAGE_NETFLIX50_BUILD_RELEASE_DEBUG),y)
NETFLIX50_CONF_OPTS += \
	-DBUILD_DEBUG=OFF \
	-DBUILD_PRODUCTION=ON \
	-DBUILD_SMALL=OFF \
	-DBUILD_STRIP=OFF \
	-DBUILD_SYMBOLS=ON \
	-DNRDP_HAS_GIBBON_QA=ON \
	-DNRDP_HAS_MUTEX_STACK=ON \
	-DNRDP_HAS_OBJECTCOUNT=ON \
	-DNRDP_HAS_QA=OFF \
	-DNRDP_HAS_TRACING=ON
else ifeq ($(BR2_PACKAGE_NETFLIX50_BUILD_RELEASE),y)
NETFLIX50_CONF_OPTS += \
	-DBUILD_DEBUG=OFF \
	-DBUILD_PRODUCTION=ON \
	-DBUILD_SMALL=OFF \
	-DBUILD_STRIP=OFF \
	-DBUILD_SYMBOLS=OFF \
	-DNRDP_HAS_GIBBON_QA=OFF \
	-DNRDP_HAS_MUTEX_STACK=OFF \
	-DNRDP_HAS_OBJECTCOUNT=ON \
	-DNRDP_HAS_QA=OFF \
	-DNRDP_HAS_TRACING=OFF
endif

ifeq ($(BR2_PACKAGE_VSS_SDK),y)
NETFLIX50_CONF_OPTS += -DUSE_DISPLAY_SETTINGS=1
endif

ifeq ($(BR2_PACKAGE_NETFLIX50_MINIFY_JS),y)
NETFLIX50_CONF_OPTS += -DJS_MINIFY=ON
NETFLIX50_DEPENDENCIES += host-nodejs

define NETFLIX50_INSTALL_NODEJS_MODULES
	npm_config_build_from_source=true \
	npm_config_nodedir=$(BUILD_DIR)/host-nodejs-$(NODEJS_VERSION) \
	npm_config_prefix=$(HOST_DIR)/usr \
	$(HOST_DIR)/usr/bin/npm  install -g uglify-js@3.0.28 jsdoc
endef

NETFLIX50_PRE_CONFIGURE_HOOKS += NETFLIX50_INSTALL_NODEJS_MODULES
endif

ifeq ($(BR2_PACKAGE_NETFLIX50_DISABLE_TOOLS), y)
NETFLIX50_CONF_OPTS += -DNRDP_TOOLS=none
else
NETFLIX50_CONF_OPTS += -DNRDP_TOOLS="provisioning"
endif


ifeq ($(BR2_PACKAGE_NETFLIX50_DRM_OCDM), y)
NETFLIX50_CONF_OPTS += -DDPI_DRM=ocdm
else ifeq ($(BR2_PACKAGE_NETFLIX50_DRM_PLAYREADY), y)
NETFLIX50_DEPENDENCIES += playready
NETFLIX50_CONF_OPTS += -DDPI_DRM=playready2.5
endif

ifeq ($(BR2_PACKAGE_NETFLIX50_LIB), y)
NETFLIX50_INSTALL_STAGING = YES
NETFLIX50_CONF_OPTS += -DGIBBON_MODE=shared
NETFLIX50_FLAGS = \
	-O3 \
	-fPIC
else
NETFLIX50_CONF_OPTS += -DGIBBON_MODE=executable
endif

ifeq ($(BR2_PACKAGE_NETFLIX50_AUDIO_MIXER), y)
NETFLIX50_DEPENDENCIES += \
	libogg \
	tremor
ifeq ($(BR2_PACKAGE_NETFLIX50_AUDIO_MIXER_SOFTWARE), y)
NETFLIX50_CONF_OPTS += \
	-DNRDP_HAS_AUDIOMIXER=ON \
	-DUSE_AUDIOMIXER_GST=ON
else ifeq ($(BR2_PACKAGE_NETFLIX50_AUDIO_MIXER_NEXUS), y)
NETFLIX50_CONF_OPTS += \
	-DNRDP_HAS_AUDIOMIXER=ON \
	-DUSE_AUDIOMIXER_NEXUS=ON
endif
else
NETFLIX50_CONF_OPTS += -DNRDP_HAS_AUDIOMIXER=OFF
endif

ifeq ($(BR2_PACKAGE_WPEFRAMEWORK_COMPOSITORCLIENT),y)
# TODO: use wpeframework instead of dummy impl
NETFLIX50_CONF_OPTS += \
	-DGIBBON_GRAPHICS=null \
	-DGIBBON_INPUT=wpeframework \
	-DGIBBON_PLATFORM=posix
NETFLIX50_DEPENDENCIES += wpeframework
endif

ifeq ($(BR2_PACKAGE_NETFLIX50_WESTEROS_SINK),y)
NETFLIX50_CONF_OPTS += -DGST_VIDEO_RENDERING=westeros
NETFLIX50_DEPENDENCIES += \
	westeros \
	westeros-sink
endif

ifeq ($(BR2_PACKAGE_WPEFRAMEWORK_PROVISIONPROXY), y)
NETFLIX50_CONF_OPTS += -DNETFLIX50_USE_PROVISION=ON
NETFLIX50_DEPENDENCIES += wpeframework
endif

ifneq ($(BR2_PACKAGE_NETFLIX50_KEYMAP),"")
NETFLIX50_CONF_OPTS += -DNETFLIX50_USE_KEYMAP=$(call qstrip,$(BR2_PACKAGE_NETFLIX50_KEYMAP))
endif

NETFLIX50_CONF_OPTS += \
	-DCMAKE_C_FLAGS="$(CMAKE_C_FLAGS) $(TARGET_CFLAGS) $(NETFLIX50_FLAGS) -I$(STAGING_DIR)/usr/include" \
	-DCMAKE_CXX_FLAGS="$(CMAKE_CXX_FLAGS) $(TARGET_CXXFLAGS) $(NETFLIX50_FLAGS) -I$(STAGING_DIR)/usr/include" \
	-DCMAKE_EXE_LINKER_FLAGS="$(CMAKE_EXE_LINKER_FLAGS) -L$(STAGING_DIR)/usr/lib" \

define NETFLIX50_FIX_CONFIG_XMLS
	mkdir -p $(@D)/netflix/src/platform/gibbon/data/etc/conf
	cp -f $(@D)/netflix/resources/configuration/common.xml $(@D)/netflix/src/platform/gibbon/data/etc/conf/common.xml
	cp -f $(@D)/netflix/resources/configuration/config.xml $(@D)/netflix/src/platform/gibbon/data/etc/conf/config.xml
endef

NETFLIX50_POST_EXTRACT_HOOKS += NETFLIX50_FIX_CONFIG_XMLS

NETFLIX50_BUILD_DIR=$(@D)/netflix/buildroot-build
NETFLIX50_DATA_DIR=/usr/share/WPEFramework/Netflix

ifeq ($(BR2_PACKAGE_NETFLIX50_LIB),y)

# TODO: fix it back
ifeq ($(BR2_PACKAGE_WPEFRAMEWORK_COMPOSITORCLIENT),y)
define NETFLIX50_INSTALL_WPEFRAMEWORK_XML
	cp $(@D)/partner/graphics/null/graphics.xml $(1)
endef
endif

ifeq ($(BR2_PACKAGE_NETFLIX50_BUILD_RELEASE),y)
define NETFLIX50_INSTALL_NETFLIX50_DATA_CONFIGS
 	$(INSTALL) -d $(1)$(NETFLIX50_DATA_DIR)/resources
	cp -a $(NETFLIX50_BUILD_DIR)/src/platform/gibbon/data/etc $(1)$(NETFLIX50_DATA_DIR)
	cp -a $(NETFLIX50_BUILD_DIR)/src/platform/gibbon/data/fonts $(1)$(NETFLIX50_DATA_DIR)
	cp -a $(NETFLIX50_BUILD_DIR)/src/platform/gibbon/data/resources/img $(1)$(NETFLIX50_DATA_DIR)/resources
	cp -a $(NETFLIX50_BUILD_DIR)/src/platform/gibbon/data/resources/js $(1)$(NETFLIX50_DATA_DIR)/resources
	cp -a $(NETFLIX50_BUILD_DIR)/src/platform/gibbon/data/resources/html $(1)$(NETFLIX50_DATA_DIR)/resources

	$(INSTALL) -d $(1)$(NETFLIX50_DATA_DIR)/etc/conf
	$(call NETFLIX50_INSTALL_WPEFRAMEWORK_XML, $(1)$(NETFLIX50_DATA_DIR)/etc/conf)
endef
endif

# TODO: fix install for 5.2
# cp -r $(@D)/artifacts/MeteringCertificate.bin $(1)/root/Netflix/artifacts
define NETFLIX50_INSTALL_TO_TARGET
	$(INSTALL) -d $(1)/usr/lib
	$(INSTALL) -m 755 $(NETFLIX50_BUILD_DIR)/src/platform/gibbon/libnetflix.so $(1)/usr/lib
	$(INSTALL) -m 755 $(NETFLIX50_BUILD_DIR)/src/platform/gibbon/libJavaScriptCore.so $(1)/usr/lib

	$(call NETFLIX50_INSTALL_NETFLIX50_DATA_CONFIGS, $(1))

	mkdir -p $(1)/root/Netflix/artifacts

endef
# TODO: fix it back
# cp -Rpf $(@D)/netflix/3rdparty/adf/*.h $(1)/usr/include/netflix/
# cp -Rpf $(@D)/netflix/3rdparty/harfbuzz/src/*.h $(1)/usr/include/netflix/
# cp -Rpf $(@D)/netflix/3rdparty/lz4/lz4.h $(1)/usr/include/3rdparty/lz4/
# cp -Rpf $(@D)/netflix/3rdparty/JavaScriptCore/Source/WTF/wtf/nrdp/Pool.h $(1)/usr/include/3rdparty/JavaScriptCore/Source/WTF/wtf/nrdp/
# cp -Rpf $(@D)/netflix/3rdparty/JavaScriptCore/Source/WTF/wtf/nrdp/Maddy.h $(1)/usr/include/3rdparty/JavaScriptCore/Source/WTF/wtf/nrdp/

define NETFLIX50_INSTALL_TO_STAGING
	$(call NETFLIX50_INSTALL_TO_TARGET, $(1))

	$(INSTALL) -d $(1)/usr/lib/pkgconfig
	$(INSTALL) -D package/netflix52/netflix.pc $(1)/usr/lib/pkgconfig/netflix.pc

	$(INSTALL) -d $(1)/usr/include/netflix
	rsync -arL $(NETFLIX50_BUILD_DIR)/include/* $(1)/usr/include/netflix

	mkdir -p $(1)/usr/include/3rdparty/JavaScriptCore/Source/WTF/wtf/nrdp
	mkdir -p $(1)/usr/include/3rdparty/lz4
	mkdir -p $(1)/usr/include/3rdparty/utf8

	cp -Rpf $(@D)/netflix/3rdparty/utf8/*.h $(1)/usr/include/3rdparty/utf8/


	cp -Rpf $(NETFLIX50_BUILD_DIR)/src/platform/gibbon/include/* $(1)/usr/include/netflix

	cp -Rpf $(@D)/netflix/src/platform/gibbon/*.h $(1)/usr/include/netflix
	cp -Rpf $(@D)/netflix/src/platform/gibbon/bridge/*.h $(1)/usr/include/netflix
	cp -Rpf $(@D)/netflix/src/platform/gibbon/text/*.h $(1)/usr/include/netflix
	cp -Rpf $(@D)/netflix/src/platform/gibbon/text/freetype/*.h $(1)/usr/include/netflix

	$(INSTALL) -d $(1)/usr/include/netflix/src
	cd $(@D)/netflix/src && find ./base/ -name "*.h" -exec cp --parents {} $(1)/usr/include/netflix/src \;
	cd $(@D)/netflix/src && find ./nrd/ -name "*.h" -exec cp --parents {} $(1)/usr/include/netflix/src \;
	cd $(@D)/netflix/src && find ./net/ -name "*.h" -exec cp --parents {} $(1)/usr/include/netflix/src \;

	find $(1)/usr/include/netflix/nrdbase/ -name "*.h" -exec sed -i "s/^#include \"\.\.\/\.\.\//#include \"/g" {} \;
	find $(1)/usr/include/netflix/nrd/ -name "*.h" -exec sed -i "s/^#include \"\.\.\/\.\.\//#include \"/g" {} \;
	find $(1)/usr/include/netflix/nrdnet/ -name "*.h" -exec sed -i "s/^#include \"\.\.\/\.\.\//#include \"/g" {} \;

	mkdir -p $(1)/usr/include/netflix/3rdparty/utf8/
	cp -Rpf $(@D)/netflix/3rdparty/utf8/* $(1)/usr/include/netflix/3rdparty/utf8/
endef

else

define NETFLIX50_INSTALL_TARGET
	$(INSTALL) -m 755 $(@D)/netflix/src/platform/gibbon/netflix $(TARGET_DIR)/usr/bin
endef

endif

define NETFLIX50_INSTALL_STAGING_CMDS
	$(call NETFLIX50_INSTALL_TO_STAGING, ${STAGING_DIR})
endef

define NETFLIX50_INSTALL_TARGET_CMDS
	$(call NETFLIX50_INSTALL_TO_TARGET, ${TARGET_DIR})
endef

define NETFLIX50_PREPARE_DPI
	mkdir -p $(TARGET_DIR)/root/Netflix/dpi
	ln -sfn /etc/playready $(TARGET_DIR)/root/Netflix/dpi/playready
endef

NETFLIX50_POST_INSTALL_TARGET_HOOKS += NETFLIX50_PREPARE_DPI

ifeq ($(BR2_PACKAGE_NETFLIX50_CREATE_BINARY_ML_DELIVERY),y)
ML_DELIVERY_SIGNATURE=${NETFLIX50_VERSION}
ML_DELIVERY_PACKAGE=${NETFLIX50_NAME}
ML_DELIVERY_DIR=${STAGING_DIR}/${BINARY_ML_DELIVERY_PACKAGE}

define CREATE_BINARY_ML_DELIVERY
	mkdir -p ${ML_DELIVERY_DIR}/usr/lib/pkgconfig/
	mkdir -p ${ML_DELIVERY_DIR}/usr/include/
	$(call NETFLIX50_INSTALL_TO_STAGING, ${ML_DELIVERY_DIR})
	$(call NETFLIX50_INSTALL_TO_TARGET, ${ML_DELIVERY_DIR})
	mkdir -p ${ML_DELIVERY_DIR}/root/Netflix/dpi
	ln -sfn /etc/playready ${ML_DELIVERY_DIR}/root/Netflix/dpi/playready
	tar -cJf ${BINARIES_DIR}/${ML_DELIVERY_PACKAGE}-${ML_DELIVERY_SIGNATURE}.tar.xz -C ${STAGING_DIR} ${ML_DELIVERY_PACKAGE}
endef

NETFLIX50_POST_INSTALL_TARGET_HOOKS += CREATE_BINARY_ML_DELIVERY
endif

$(eval $(cmake-package))
